#!/usr/bin/env bash

set -euo pipefail

if ! command -v cursor >/dev/null 2>&1 && [[ ! -d "$HOME/.cursor" ]]; then
  echo "Warning: Cursor does not appear to be installed (no cursor CLI and no ~/.cursor directory)." >&2
  echo "The plugins will be copied, but you will need Cursor to use them." >&2
  echo
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PLUGIN_ROOT="$REPO_ROOT/plugins"
TARGET_ROOT="${CURSOR_PLUGIN_LOCAL_DIR:-$HOME/.cursor/plugins/local}"
INSTALL_MODE="${CURSOR_AUTHSTACK_INSTALL_MODE:-auto}"

if [[ ! -d "$PLUGIN_ROOT" ]]; then
  echo "Plugin directory not found: $PLUGIN_ROOT" >&2
  exit 1
fi

case "$INSTALL_MODE" in
  auto)
    if [[ -n "${CURSOR_AUTHSTACK_SOURCE_DIR:-}" ]]; then
      INSTALL_MODE="symlink"
    else
      INSTALL_MODE="copy"
    fi
    ;;
  copy|symlink)
    ;;
  *)
    echo "Unsupported install mode: $INSTALL_MODE" >&2
    echo "Use CURSOR_AUTHSTACK_INSTALL_MODE=copy or symlink." >&2
    exit 1
    ;;
esac

mkdir -p "$TARGET_ROOT"

echo "Installing Scalekit Auth Stack for Cursor"
echo "Repository: $REPO_ROOT"
echo "Target: $TARGET_ROOT"
echo "Mode: $INSTALL_MODE"
echo

installed_plugins=()

for plugin_dir in "$PLUGIN_ROOT"/*; do
  [[ -d "$plugin_dir" ]] || continue

  source_manifest="$plugin_dir/.cursor-plugin/plugin.json"
  plugin_slug="$(basename "$plugin_dir")"
  target_path="$TARGET_ROOT/$plugin_slug"
  target_manifest="$target_path/.cursor-plugin/plugin.json"

  if [[ ! -f "$source_manifest" ]]; then
    echo "Skipping $plugin_slug: missing .cursor-plugin/plugin.json"
    continue
  fi

  rm -rf "$target_path"

  if [[ "$INSTALL_MODE" == "symlink" ]]; then
    ln -s "$plugin_dir" "$target_path"
    action="Linked"
  else
    mkdir -p "$target_path"
    cp -R "$plugin_dir"/. "$target_path"
    action="Copied"
  fi

  if [[ ! -f "$target_manifest" ]]; then
    echo "Failed to install $plugin_slug: missing installed manifest at $target_manifest" >&2
    exit 1
  fi

  echo "$action  $plugin_slug -> $target_path"
  installed_plugins+=("$plugin_slug")
done

if [[ "${#installed_plugins[@]}" -eq 0 ]]; then
  echo
  echo "No installable Cursor plugins were found under $PLUGIN_ROOT." >&2
  exit 1
fi

echo
echo "Installed plugins:"
for plugin_slug in "${installed_plugins[@]}"; do
  echo "  - $plugin_slug"
done

echo
echo "What to do next in Cursor:"
echo "  - Restart Cursor (or reload the window)."
echo "  - Look for \"agentkit\" and \"saaskit\" in your plugin settings."
echo "  - Make sure both are installed and enabled."
echo "  - Set the update policy to auto-update so you always have the latest skills."
echo
echo "To verify it works:"
echo "  Ask Cursor to \"help me integrate agentkit\" or \"test my auth setup\"."
