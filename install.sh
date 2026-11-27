#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# Preferences
# ------------------------------------------------------------------------------

# Where the dotfiles repo was cloned
DOTFILES_DIR="$HOME/dotfiles"

# Default theme — use names like `tokyo-night` instead of `Tokyo Night`.
#  See `/usr/bin/omarchy-theme-set`
DEFAULT_THEME="kanagawa"

# Default browser
#  See `/usr/bin/omarchy-default-browser`
DEFAULT_BROWSER="brave-origin"

# ------------------------------------------------------------------------------
# Utility functions
# ------------------------------------------------------------------------------

force_link() {
  src="$1"
  dest="$2"
  parent="$(dirname "$dest")"

  # Use sudo only if we can't write to the parent directory — creating, moving,
  # or removing an entry depends on write permission to the directory
  # containing it, not the entry itself.
  if [ -w "$parent" ]; then
    run=""
  else
    run="sudo"
  fi

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    return 0 # already correct
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    # Backup any existing file/directory
    $run mv "$dest" "$dest.bak.$(date +%s)"
  fi

  $run ln -s "$src" "$dest"
}

# ------------------------------------------------------------------------------
# Bash
# ------------------------------------------------------------------------------

#  Symlink specific files
force_link "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"

# ------------------------------------------------------------------------------
# Default browser
# ------------------------------------------------------------------------------

omarchy install browser "$DEFAULT_BROWSER"
omarchy default browser "$DEFAULT_BROWSER"

# Install extensions automatically (brave/brave-origin only)
case "$DEFAULT_BROWSER" in
"brave" | "brave-origin")
  sudo mkdir -p "/etc/brave/policies/managed"
  force_link "$DOTFILES_DIR/brave/extensions.json" /etc/brave/policies/managed/extensions.json
  ;;
esac

# ------------------------------------------------------------------------------
# Hyprland
# ------------------------------------------------------------------------------

# Replace default files
#  Do it on a per-file basis, not the whole directory. You can see which files
#  are sourced in `~/.config/hypr/hyprland.lua`.
force_link "$DOTFILES_DIR/hypr/autostart.lua" "$HOME/.config/hypr/autostart.lua"
force_link "$DOTFILES_DIR/hypr/bindings.lua" "$HOME/.config/hypr/bindings.lua"
force_link "$DOTFILES_DIR/hypr/input.lua" "$HOME/.config/hypr/input.lua"
force_link "$DOTFILES_DIR/hypr/looknfeel.lua" "$HOME/.config/hypr/looknfeel.lua"
force_link "$DOTFILES_DIR/hypr/monitors.lua" "$HOME/.config/hypr/monitors.lua"

# ------------------------------------------------------------------------------
# Keyd
# ------------------------------------------------------------------------------

omarchy pkg add keyd

force_link "$DOTFILES_DIR/keyd" /etc/keyd

if ! systemctl is-enabled --quiet "keyd.service"; then
  sudo systemctl enable "keyd.service"
  echo "Enabled keyd service"
fi
if ! systemctl is-active --quiet "keyd.service"; then
  sudo systemctl start "keyd.service"
  echo "Started keyd service"
fi

# ------------------------------------------------------------------------------
# Neovim
# ------------------------------------------------------------------------------

force_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# ------------------------------------------------------------------------------
# Omarchy
# ------------------------------------------------------------------------------

# Set theme
omarchy theme set "$DEFAULT_THEME"

# Set background
#  Symlink backgrounds directory
force_link "$DOTFILES_DIR/omarchy/backgrounds" "$HOME/.config/omarchy/backgrounds"
#  If you want to set a custom background, include a `default.jpg` for the
#  desired theme.
DEFAULT_BACKGROUND="$HOME/.config/omarchy/backgrounds/$DEFAULT_THEME/default.jpg"
if [[ -f "$DEFAULT_BACKGROUND" ]]; then
  omarchy theme bg set "$DEFAULT_BACKGROUND"
fi

# Configure Top Bar
#  Doing changes with commands (instead of a dotfile) means that you can
#  recreate default files to include any new upstream changes, and then run the
#  script to apply our preferences.
omarchy plugin disable omarchy.menu
omarchy bar background glassy
# omarchy bar position right

# Remove some webapps
omarchy webapp remove "Hey"
omarchy webapp remove "Basecamp"
omarchy webapp remove "ChatGPT"
omarchy webapp remove "Grok"
omarchy webapp remove "Google Messages"
omarchy webapp remove "Google Photos"
omarchy webapp remove "Google Contacts"

# Install webapps
#  Only install web apps if you want to open them through the Omarchy menu,
#  otherwise just set a keybind. The third argument is required — leave it
#  empty (`""`) to retrieve it from favicon.
# omarchy webapp install "<name>" "<url>" "<icon-url>"

# ------------------------------------------------------------------------------
# Yazi
# ------------------------------------------------------------------------------

omarchy pkg add yazi
force_link "$DOTFILES_DIR/yazi" "$HOME/.config/yazi"

# ------------------------------------------------------------------------------
# Install packages that don't require config files
# ------------------------------------------------------------------------------

# Hex
#  NOTE: manually download the "Parakeet v3" model for spanish/english recognition
omarchy pkg aur add hex-bin
if ! hex status >/dev/null 2>&1; then
  hex start
fi

# Flea
omarchy pkg add flea

# Bitwarden
#  The installer script throws and error message due to conflicting nodejs
#  installations. Use the browser extension meanwhile.

# Dropbox
omarchy install service dropbox

# Tailscale
omarchy install service tailscale

# ------------------------------------------------------------------------------
# Remove some packages
# ------------------------------------------------------------------------------

#omarchy pkg drop [package]
