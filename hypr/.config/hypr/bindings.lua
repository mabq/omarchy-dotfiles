hl.unbind "SUPER + slash" -- Monitor scaling up
hl.unbind "SUPER + Alt + slash" -- Monitor scaling down
hl.unbind "SUPER + Shift + slash" -- Passwords
hl.unbind "SUPER + J" -- Toggle window split
hl.unbind "SUPER + K" -- Keybindings
hl.unbind "SUPER + L" -- Toogles workspace layout
hl.unbind "SUPER + LEFT" -- Focus on left window
hl.unbind "SUPER + RIGHT" --Focus on right window
hl.unbind "SUPER + UP" -- Focus on up window
hl.unbind "SUPER + DOWN" -- Focus on down window
hl.unbind "SUPER + SHIFT + LEFT" -- Swap window to the left
hl.unbind "SUPER + SHIFT + RIGHT" --Swap window to the right
hl.unbind "SUPER + SHIFT + UP" -- Swap window up
hl.unbind "SUPER + SHIFT + DOWN" -- Swap window down
hl.unbind "SUPER + COMMA" -- Dismiss last notification
hl.unbind "SUPER + code:20" -- Expand window left
hl.unbind "SUPER + F" -- "Full screen"

-- o.bind("SUPER + H", "Focus on left window", hl.dsp.focus { direction = "l" }) -- does not work on fullscreen windows
-- o.bind("SUPER + L", "Focus on right window", hl.dsp.focus { direction = "r" })
-- o.bind("SUPER + K", "Focus on above window", hl.dsp.focus { direction = "u" })
-- o.bind("SUPER + J", "Focus on below window", hl.dsp.focus { direction = "d" })
o.bind("SUPER + H", "Focus on left window", hl.dsp.layout "focus l") -- works on fullscreen windows
o.bind("SUPER + L", "Focus on right window", hl.dsp.layout "focus r")
o.bind("SUPER + J", "Focus on below window", hl.dsp.layout "focus d")
o.bind("SUPER + K", "Focus on above window", hl.dsp.layout "focus u")
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap { direction = "l" })
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap { direction = "r" })
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap { direction = "u" })
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap { direction = "d" })
o.bind("SUPER + Z", "Hide menus", hl.dsp.window.fullscreen_state { action = "toggle", internal = -1, client = 2 })
o.bind(
  "SUPER + F",
  "Full screen (with menus)",
  hl.dsp.window.fullscreen_state { action = "toggle", internal = 2, client = -1 }
)
o.bind("SUPER + COMMA", "Column shrink", hl.dsp.layout "colresize -0.1")
o.bind("SUPER + PERIOD", "Column grow", hl.dsp.layout "colresize +0.1")
o.bind("SUPER + code:20", "Toggle previous workspace", hl.dsp.focus { workspace = "previous" })
o.bind("SUPER + DELETE", "Dismiss last notification", "omarchy-shell notifications dismissOne")
o.bind("SUPER + SLASH", "Toggle window split", hl.dsp.layout "togglesplit")
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + SHIFT + SLASH", "Keybindings", "omarchy-menu-keybindings")

-- Dictation keys from before Alt + Space and Right Alt became the defaults.
-- Remove these lines to give the keys back to applications.
if o.dictation_installed and o.dictation_installed() then
  o.bind("SUPER + CTRL + X", "Toggle dictation", "omarchy-dictation toggle")
  o.bind_hold(
    "F9",
    "Start dictation (push-to-talk)",
    "omarchy-dictation start",
    "Stop dictation (push-to-talk)",
    "omarchy-dictation stop"
  )
end

-- Hex dictation. Hyprland owns global shortcuts on Wayland, so Hex cannot
-- grab a key itself; bind its commands here. Hold Alt + Space to talk.
o.bind_hold(
  "ALT + SPACE",
  "Dictate (Hex)",
  "/home/mabq/.local/bin/hex dictation start",
  "Stop dictating (Hex)",
  "/home/mabq/.local/bin/hex dictation stop"
)
