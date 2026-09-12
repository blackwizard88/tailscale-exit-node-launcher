#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
TARGET_DIR="$DATA_HOME/tailscale-exit-node-launcher"
APP_DIR="$DATA_HOME/applications"
SCRIPT_TARGET="$TARGET_DIR/tailscale-exit-node.sh"
DESKTOP_TARGET="$APP_DIR/tailscale-exit-node.desktop"

required_files=(
  "$SRC_DIR/tailscale-exit-node.sh"
  "$SRC_DIR/tailscale-exit-node.desktop.in"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    printf 'Missing installer file: %s\n' "$file" >&2
    exit 1
  fi
done

mkdir -p "$TARGET_DIR" "$APP_DIR"
install -m 0755 "$SRC_DIR/tailscale-exit-node.sh" "$SCRIPT_TARGET"

# Escape characters that are special in sed replacement strings.
escaped_script_path=${SCRIPT_TARGET//\\/\\\\}
escaped_script_path=${escaped_script_path//&/\\&}
escaped_script_path=${escaped_script_path//|/\\|}

sed "s|__SCRIPT_PATH__|$escaped_script_path|g" \
  "$SRC_DIR/tailscale-exit-node.desktop.in" \
  > "$DESKTOP_TARGET"
chmod 0644 "$DESKTOP_TARGET"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true
fi

cat <<EOF2

Installed successfully.

Application: Tailscale Exit Node
Launcher:    $SCRIPT_TARGET
Desktop:     $DESKTOP_TARGET

Open your desktop environment's application menu and search for:
  Tailscale Exit Node

EOF2
