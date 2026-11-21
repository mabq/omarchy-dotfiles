--------------------------------------------------------------------------------

-- Make scrolling mode work properly:
--
--   Omarchy offers 3 different layout modes: Dwindle (default), Floating and
--   Scrolling. I want only Scrolling mode enabled.
--
--   This section configures keybinds with dispatchers that work properly in
--   Scrolling layout mode (specially with fullscreen windows) — Omarchy
--   default keybinds use general purpose dispatchers that work properly in
--   Dwindle mode. For more information, visit:
--     https://wiki.hypr.land/configuring/layouts/scrolling-layout/
--
--   Some default bindings are only meant for other layout modes, those and
--   reused for other purposes.

-- Configurations related to scrolling mode
hl.config {
  scrolling = {
    wrap_focus = false,
    wrap_swapcol = false,
    column_width = 0.5,
    follow_min_visible = 1,
  },
}

-- Last window
--   Since we don´t need to cycle through different layout modes, we use this
--   keybind for other purpose.
hl.unbind "SUPER + L" -- Default: Cycle workspace layout
o.bind("SUPER + L", "Focus last window", hl.dsp.focus { urgent_or_last = true })

-- Remove unused keybind
--   This is only applicable for Dwindle
hl.unbind "SUPER + J" -- Default: Toogle window split

-- Resize columns
--   Replace the `hl.dsp.window.resize` dispatcher used by Omarchy default
--   keybinds with `colresize`, which is a specialized dispatcher for Scrolling
--   layout mode. Note that this dispatcher won't work on floating windows.
--
--   With `hl.dsp.window.resize` the right-most window does not grow when its
--   right side is already touching the right side of the screen (even when the
--   column still has room to grow on the other side).
hl.unbind "SUPER + minus" -- "Expand window left"
hl.unbind "SUPER + equal" -- "Shrink window left"
o.bind("SUPER + minus", "Resize column (grow)", hl.dsp.layout "colresize -0.1", { repeating = true })
--   Use `+` instead of `=`
o.bind("SUPER + SHIFT + equal", "Resize column (shrink)", hl.dsp.layout "colresize +0.1", { repeating = true })
--   The default bind to `M` is not applicable to scrolling mode, so use it expand (maximize)
hl.unbind "SUPER + M" -- Default: "Minimize window to the dock"
o.bind("SUPER + M", "Full width", hl.dsp.window.fullscreen { mode = "maximized" })

-- Focus columns
--   Replace the `hl.dsp.focus` dispatcher used by Omarchy default keybinds
--   with `hl.dsp.layout "focus x"`, which is a specialized dispatcher for
--   Scrolling layout mode. `hl.dsp.focus` does not work in fullscreen windows.
hl.unbind "SUPER + LEFT" -- "Focus on left window"
hl.unbind "SUPER + RIGHT" -- "Focus on right window"
hl.unbind "SUPER + UP" -- "Focus on above window"
hl.unbind "SUPER + DOWN" -- "Focus on below window"
o.bind("SUPER + LEFT", "Focus on left window", hl.dsp.layout "focus l")
o.bind("SUPER + RIGHT", "Focus on right window", hl.dsp.layout "focus r")
o.bind("SUPER + UP", "Focus on below window", hl.dsp.layout "focus u")
o.bind("SUPER + DOWN", "Focus on above window", hl.dsp.layout "focus d")

-- Swap columns
--   Replace the `hl.dsp.window.swap` dispatcher used by Omarchy default
--   keybinds with `hl.dsp.layout "swap x"`, which is a specialized dispatcher
--   for Scrolling layout mode. `hl.dsp.window.swap` does not work in
--   fullscreen windows.
hl.unbind "SUPER + SHIFT + LEFT" -- "Swap window to the left"
hl.unbind "SUPER + SHIFT + RIGHT" -- "Swap window to the right"
o.bind("SUPER + SHIFT + LEFT", "Swap column to the left", hl.dsp.layout "swapcol l")
o.bind("SUPER + SHIFT + RIGHT", "Swap column to the right", hl.dsp.layout "swapcol r")

-- Fullscreen window
--   The default keybind makes the application go into fullscreen mode, I
--   prefer to only make the window fullscreen and leave the app content as is.
hl.unbind "SUPER + F" -- "Full screen"
o.bind(
  "SUPER + F",
  "Full screen (window)",
  hl.dsp.window.fullscreen_state {
    action = "toggle",
    internal = 2, -- window
    client = -1, -- application
    layout_aware = true,
  }
)

-- Fullscreen content
--   The default keybind messes up the fullscreen window mode of the window, I
--   prefer this keybind to only manage the fullscreen mode of the app (not the
--   window).
hl.unbind "SUPER + CTRL + F" -- "Tiled full screen"
o.bind(
  "SUPER + CTRL + F",
  "Full screen (content)",
  hl.dsp.window.fullscreen_state {
    action = "toggle",
    internal = -1, -- window
    client = 2, -- application
    layout_aware = true,
  }
)

--------------------------------------------------------------------------------

-- Hex dictation. Hyprland owns global shortcuts on Wayland, so Hex cannot
-- grab a key itself; bind its commands here. Hold Alt + Space to talk.
o.bind_hold(
  "ALT + SPACE",
  "Dictate (Hex)",
  "/home/mabq/.local/bin/hex dictation start",
  "Stop dictating (Hex)",
  "/home/mabq/.local/bin/hex dictation stop"
)
