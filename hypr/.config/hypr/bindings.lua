--[[

  NOTES:

    It seems that Hyprland is trying to do too much, there are too many layout
    modes and not all dispatchers work properly in all of them. The Scrolling
    layout is not even near as polished as it is in Niri.

    The compositor part could be easily replaced in other distros with Niri and
    have a much better personalized experience. Omarchy overly complicate
    things in order to please as much people as possible.

    For more information visit Omarchy's keybinds manual page:
      https://omarchy.org/manual/hotkeys/

--]]

--------------------------------------------------------------------------------
-- System actions --
--------------------------------------------------------------------------------

-- Disable duplicated keybind, user `SUPER + W` instead
hl.unbind "SUPER + Q"

-- Easier than `SUPER + CTRL + Tab` for such a common action. This keybind is free.
o.bind("SUPER + b", "Back to last workspace", hl.dsp.focus { workspace = "previous_per_monitor" })

-- Do not touch app fullscreen mode, just window state.
hl.unbind "SUPER + F"
o.bind(
  "SUPER + F",
  "Full screen (window)",
  hl.dsp.window.fullscreen_state {
    action = "toggle",
    internal = 2, -- window
    client = -1, -- application
  }
)

-- Do not touch window fullscreen state, just app fullscreen state.
hl.unbind "SUPER + CTRL + F"
o.bind(
  "SUPER + CTRL + F",
  "Full screen (window content)",
  hl.dsp.window.fullscreen_state {
    action = "toggle",
    internal = -1, -- window
    client = 2, -- application
  }
)

--------------------------------------------------------------------------------
-- Apps --
--------------------------------------------------------------------------------

-- Replace Hey email app with iCloud
hl.unbind "SUPER + SHIFT + E"
o.bind("SUPER + SHIFT + E", "Email", { webapp = "https://www.icloud.com/mail/" })

-- Replace Signal with Whatsapp
hl.unbind "SUPER + SHIFT + G"
o.bind("SUPER + SHIFT + G", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })

-- Add hex dictation — completely local voice to text app.
-- Use the "Parakeet V3" model for English/Spanish dictation.
o.bind_hold(
  "SUPER + h", -- this keybind is free
  "Dictate (Hex)",
  "/home/mabq/.local/bin/hex dictation start",
  "Stop dictating (Hex)",
  "/home/mabq/.local/bin/hex dictation stop"
)

-- flea --default: begin. Written by `flea --default`; `flea --default off` removes the block whole.
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", { launch = 'flea --gui' })
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { launch = 'flea --gui "$(omarchy-cmd-terminal-cwd)"' })
-- flea --default: end.

-- flea --picker: begin. Written by `flea --picker`; `flea --picker off` removes the block whole.
o.window("com.thisisgm.flea.picker", { tag = "+floating-window" })
-- flea --picker: end.
