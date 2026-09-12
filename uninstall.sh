#!/usr/bin/env bash
set -euo pipefail

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
TARGET_DIR="$DATA_HOME/tailscale-exit-node-launcher"
APP_DIR="$DATA_HOME/applications"
DESKTOP_TARGET="$APP_DIR/tailscale-exit-node.desktop"

rm -rf "$TARGET_DIR"
rm -f "$DESKTOP_TARGET"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true
fi

printf 'Tailscale Exit Node Launcher removed.\n'
