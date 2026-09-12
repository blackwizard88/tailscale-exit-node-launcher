#!/usr/bin/env bash
set -u

APP_NAME="Tailscale Exit Node"

TAILSCALE_BIN="$(command -v tailscale || true)"
ZENITY_BIN="$(command -v zenity || true)"
PYTHON_BIN="$(command -v python3 || true)"
PKEXEC_BIN="$(command -v pkexec || true)"

show_error() {
  local msg="$1"
  if [[ -n "$ZENITY_BIN" ]]; then
    "$ZENITY_BIN" --error --title="$APP_NAME" --text="$msg" 2>/dev/null || true
  else
    printf 'Error: %s\n' "$msg" >&2
  fi
}

show_info() {
  local msg="$1"
  if [[ -n "$ZENITY_BIN" ]]; then
    "$ZENITY_BIN" --info --title="$APP_NAME" --text="$msg" 2>/dev/null || true
  else
    printf '%b\n' "$msg"
  fi
}

missing=()
[[ -n "$TAILSCALE_BIN" ]] || missing+=("tailscale")
[[ -n "$ZENITY_BIN" ]] || missing+=("zenity")
[[ -n "$PYTHON_BIN" ]] || missing+=("python3")

if (( ${#missing[@]} > 0 )); then
  printf -v missing_text '%s, ' "${missing[@]}"
  missing_text="${missing_text%, }"
  show_error "Missing required program(s): ${missing_text}\n\nInstall them with your distribution's package manager, then try again."
  exit 1
fi

STATUS_JSON="$("$TAILSCALE_BIN" status --json 2>/dev/null)" || {
  show_error "Could not read Tailscale status. Make sure Tailscale is installed, running, and this device is connected to your tailnet."
  exit 1
}

# Rows consumed by Zenity:
# selected<TAB>display name<TAB>Tailscale IP
mapfile -t ROWS < <(
  printf '%s' "$STATUS_JSON" | "$PYTHON_BIN" -c '
import json
import sys

data = json.load(sys.stdin)
peers = data.get("Peer", {}) or {}

current = None
for peer in peers.values():
    if peer.get("ExitNode"):
        current = peer
        break

print(("TRUE" if current is None else "FALSE") + "\tDisable exit node\t__OFF__")

for peer in peers.values():
    if not peer.get("ExitNodeOption"):
        continue

    ips = peer.get("TailscaleIPs") or []
    ip = ips[0] if ips else ""
    dns = (peer.get("DNSName") or "").rstrip(".")
    host = peer.get("HostName") or ""
    name = host or dns or ip or "Unknown device"

    if dns and dns != name:
        name = f"{name} ({dns})"

    # Keep Zenity list rows well-formed.
    name = name.replace("\t", " ").replace("\n", " ")
    selected = "TRUE" if peer.get("ExitNode") else "FALSE"
    print(f"{selected}\t{name}\t{ip}")
'
)

if (( ${#ROWS[@]} <= 1 )); then
  show_error "No available exit nodes were found in this tailnet."
  exit 1
fi

ZENITY_ARGS=(
  --list
  --radiolist
  --title="$APP_NAME"
  --text="Choose the exit node for this device:"
  --column=""
  --column="Exit node"
  --column="Tailscale IP"
  --hide-column=3
  --width=560
  --height=380
  --print-column=3
)

for row in "${ROWS[@]}"; do
  IFS=$'\t' read -r checked name ip <<< "$row"
  ZENITY_ARGS+=("$checked" "$name" "$ip")
done

CHOICE="$("$ZENITY_BIN" "${ZENITY_ARGS[@]}" 2>/dev/null)"
rc=$?
if [[ $rc -ne 0 || -z "$CHOICE" ]]; then
  exit 0
fi

run_tailscale_set() {
  # First try without privilege escalation. This works when the current user
  # is configured as a Tailscale operator. Otherwise fall back to Polkit.
  if "$TAILSCALE_BIN" set "$@" >/dev/null 2>&1; then
    return 0
  fi

  if [[ -z "$PKEXEC_BIN" ]]; then
    show_error "Changing the exit node requires elevated privileges on this system, but pkexec (Polkit) is not available.\n\nEither install Polkit/pkexec or configure your user as a Tailscale operator."
    return 1
  fi

  "$PKEXEC_BIN" "$TAILSCALE_BIN" set "$@"
}

if [[ "$CHOICE" == "__OFF__" ]]; then
  if run_tailscale_set --exit-node=; then
    show_info "Exit node disabled."
  else
    show_error "Could not disable the exit node."
    exit 1
  fi
else
  # Safer default for laptops on untrusted/public networks:
  # do not expose the local LAN while routing through an exit node.
  if run_tailscale_set --exit-node="$CHOICE" --exit-node-allow-lan-access=false; then
    show_info "Exit node enabled:\n$CHOICE"
  else
    show_error "Could not set the selected exit node."
    exit 1
  fi
fi
