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
-- hl.unbind "SUPER + F" -- "Full screen"

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus { direction = "l" })
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus { direction = "r" })
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus { direction = "u" })
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus { direction = "d" })
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap { direction = "l" })
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap { direction = "r" })
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap { direction = "u" })
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap { direction = "d" })
o.bind(
  "SUPER + Z",
  "Full screen (keep tabs)",
  hl.dsp.window.fullscreen_state { action = "toggle", internal = 2, client = -1 }
)
o.bind("SUPER + COMMA", "Column shrink", hl.dsp.layout "colresize -0.1")
o.bind("SUPER + PERIOD", "Column grow", hl.dsp.layout "colresize +0.1")
o.bind("SUPER + code:20", "Toggle previous workspace", hl.dsp.focus { workspace = "previous" })
o.bind("SUPER + DELETE", "Dismiss last notification", "omarchy-shell notifications dismissOne")
o.bind("SUPER + SLASH", "Toggle window split", hl.dsp.layout "togglesplit")
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + SHIFT + SLASH", "Keybindings", "omarchy-menu-keybindings")
