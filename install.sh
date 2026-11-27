#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------

# Default theme — use names like `tokyo-night` instead of `Tokyo Night`.
#  See `/usr/bin/omarchy-theme-set`
DEFAULT_THEME="kanagawa"

# Default browser
#  See `/usr/bin/omarchy-default-browser`
DEFAULT_BROWSER="brave-origin"

# ------------------------------------------------------------------------------
# Dotfiles (home)
# ------------------------------------------------------------------------------

# Put dotfiles in place — put system-level files in the hidden directory `.system/`

dotfiles_dir="$HOME/dotfiles"
packages=()

for entry in "$dotfiles_dir"/*/; do
  [ -d "$entry" ] || continue
  pkg="$(basename "$entry")"
  case "$pkg" in
  .*) continue ;; # skip hidden directories
  esac
  packages+=("$pkg")
done

stow -d "$dotfiles_dir" -t "$HOME" "${packages[@]}"

# ------------------------------------------------------------------------------
# Navigation
# ------------------------------------------------------------------------------

# Review Hyprland's bindings file for changes — try to stick with defaults.

#  Many Hyprland dispatchers don't work well in Scrolling mode, for example:
#  - The right-most window won't grow, even when there is still room to do
#    so, if the right part of the window is already at the right edge.
#  - Can't change focus when a window is in full-screen mode (same on
#    tiling mode).
#  - Cant' swap windows when they are in full-screen mode.

# ------------------------------------------------------------------------------
# The Top Bar
# ------------------------------------------------------------------------------

# Make changes via commands, later you can regenerate default config files to
# include any new Omarchy defaults and rerun this script to apply these changes
# on top.

# Remove omarchy icon from bar
omarchy plugin disable omarchy.menu

# Put the bar on the right
# omarchy bar position right

# Make it glassy
omarchy bar background glassy

# ------------------------------------------------------------------------------
# Themes
# ------------------------------------------------------------------------------

omarchy theme set "$DEFAULT_THEME"

# ------------------------------------------------------------------------------
# Background
# ------------------------------------------------------------------------------

# Include a background called `default.jpg` in theme dotfiles if you want to
# set a custom background automatically.
BACKGROUND="$HOME/.config/omarchy/backgrounds/$DEFAULT_THEME/default.jpg"
if [[ -f "$BACKGROUND" ]]; then
  omarchy theme bg set "$BACKGROUND"
fi

# ------------------------------------------------------------------------------
# Browsers
# ------------------------------------------------------------------------------

# Setup default browser
omarchy install browser "$DEFAULT_BROWSER"
omarchy default browser "$DEFAULT_BROWSER"

# Install extensions automatically (brave/brave-origin only)
case "$DEFAULT_BROWSER" in
"brave" | "brave-origin")
  sudo mkdir -p "/etc/brave/policies/managed"
  sudo ln -sf "$dotfiles_dir/.brave/extensions.json" /etc/brave/policies/managed/extensions.json
  ;;
esac

# ------------------------------------------------------------------------------
# Commercial Services
# ------------------------------------------------------------------------------

# Bitwarden
#   The installer script throws and error message due to conflicting nodejs
#   installations. Use the browser extension meanwhile.

# Dropbox
omarchy install service dropbox

# Tailscale
#   The tailscale omarche shell plugin is pretty cool
omarchy install service tailscale

# ------------------------------------------------------------------------------
# Web Apps
# ------------------------------------------------------------------------------

# Remove stuff I never use
omarchy webapp remove "Hey"
omarchy webapp remove "Basecamp"
omarchy webapp remove "ChatGPT"
omarchy webapp remove "Grok"
omarchy webapp remove "Google Messages"
omarchy webapp remove "Google Photos"
omarchy webapp remove "Google Contacts"

# Install new ones
#  Only install web apps if you want to open them through the Omarchy menu,
#  otherwise just set a keybind.
#
#  The third argument is required — leave it empty (`""`) to retrieve it from favicon.
omarchy webapp install "<name>" "<url>" "<icon-url>"

# ------------------------------------------------------------------------------
# Windows VM
# ------------------------------------------------------------------------------

# If there is any program you still need for which there is no alternative in
# Linux, you can run Windows inside Omarchy. The installation is dead-simple
# through the main menu.

# ------------------------------------------------------------------------------
# Add other packages
# ------------------------------------------------------------------------------

# Keyd
omarchy pkg add keyd
if [ ! -d /etc/keyd ]; then
  sudo ln -sf "$dotfiles_dir/.keyd/default" /etc/keyd
fi
if ! systemctl is-enabled --quiet "keyd.service"; then
  sudo systemctl enable "keyd.service"
  echo "Enabled keyd service"
fi
if ! systemctl is-active --quiet "keyd.service"; then
  sudo systemctl start "keyd.service"
  echo "Started keyd service"
fi

# Flea
omarchy pkg add flea

# Yazi
omarchy pkg add yazi

# Hex
#  Manually download the "Parakeet v3" model for spanish/english recognition
omarchy pkg aur add hex-bin
if ! hex status >/dev/null 2>&1; then
  hex start
fi

# ------------------------------------------------------------------------------
# Remove packages
# ------------------------------------------------------------------------------

# Remove unnecessary packages
#omarchy pkg drop [package]

exit
