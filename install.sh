#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------

# Default theme — use names like `tokyo-night` instead of `Tokyo Night`.
#  See `/usr/share/omarchy/bin/omarchy-theme-set`
DEFAULT_THEME="kanagawa"

# Default browser
#  See `/usr/share/omarchy/bin/omarchy-default-browser`
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

# Remove omarchy icon from bar
omarchy plugin disable omarchy.menu

# Put the bar on the right
omarchy bar position right

# Make it glassy
omarchy bar background glassy

# ------------------------------------------------------------------------------
# Themes
# ------------------------------------------------------------------------------

omarchy theme set "$DEFAULT_THEME"

# ------------------------------------------------------------------------------
# Background
# ------------------------------------------------------------------------------

# Include a background called `default.jpg` if theme dotfiles if you want to
# set it automatically.
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
  sudo ln -sf "$dotfiles_dir/.system/brave/extensions.json" /etc/brave/policies/managed/extensions.json
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

exit

# -- Web Apps ------------------------------------------------------------------

# -- Remove
omarchy webapp remove Hey
omarchy webapp remove Basecamp
omarchy webapp remove ChatGPT
omarchy webapp remove Grok
omarchy webapp remove "Google Messages"
omarchy webapp remove "Google Photos"
omarchy webapp remove "Google Contacts"

# -- Install
omarchy webapp install "iCloud Email" "https://www.icloud.com/mail/" "" # -- empty icon url

# -- PDFs ----------------------------------------------------------------------

#    This is where all available Linux apps disappoint, none of them come even
#    close to what is available in MacOS/Windows.

# -- Windows VM ----------------------------------------------------------------
#    Run Windows inside Omarchy with a single command, wow!

# -- Other packages ------------------------------------------------------------

#    Install addtional packages from the official repository
omarchy pkg add keyd flea

#    Install additional packages from AUR (be careful)
omarchy pkg add aur hex-bin

#    Remove unnecessary packages
# omarchy pkg drop [package]
