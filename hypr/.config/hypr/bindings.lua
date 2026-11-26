--[[

  NOTES:

    It seems like Hyprland is trying to do too much, there are too many layout
    modes and not all dispatchers work properly in all of them. The Scrolling
    layout is not even near as polished as it is in Niri.

    The compositor part could be easily replaced in other distros with Niri and
    have a much better  experience. Omarchy has to overly complicate things in
    order to please a broader audience.

    For more information visit Omarchy's keybinds manual page:
      https://omarchy.org/manual/hotkeys/

--]]

--------------------------------------------------------------------------------
-- System actions --
--------------------------------------------------------------------------------

-- Delete keybind — `SUPER + W` is enough
hl.unbind "SUPER + Q"

-- New keybind - easier than `SUPER + CTRL + Tab`
o.bind("SUPER + b", "Back to last workspace", hl.dsp.focus { workspace = "previous_per_monitor" })

-- Improve the keybind — do not touch app state when doing a window fullscreen
hl.unbind "SUPER + F"
o.bind(
  "SUPER + F",
  "Full screen (window)",
  hl.dsp.window.fullscreen_state {
    action = "toggle",
    internal = 2, -- window
    client = -1, -- app
  }
)

-- Improve the keybind — do not touch window state when doing an app fullscreen
hl.unbind "SUPER + CTRL + F"
o.bind(
  "SUPER + CTRL + F",
  "Full screen (window content)",
  hl.dsp.window.fullscreen_state {
    action = "toggle",
    internal = -1, -- window
    client = 2, -- app
  }
)

--------------------------------------------------------------------------------
-- Apps --
--------------------------------------------------------------------------------

-- Change keybind — I don't use Hey, so take the keymap for iCloud mail
hl.unbind "SUPER + SHIFT + E"
o.bind("SUPER + SHIFT + E", "Email", { webapp = "https://www.icloud.com/mail/" })

-- Change keybind — I dont use Signal, so take the easier keybind for Whatsapp
hl.unbind "SUPER + SHIFT + G"
o.bind("SUPER + SHIFT + G", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })

-- New keybind — Hex dictation (use the "Parakeet v3" model for english/spanish)
o.bind_hold(
  "SUPER + h",
  "Dictate (Hex)",
  "/home/mabq/.local/bin/hex dictation start",
  "Stop dictating (Hex)",
  "/home/mabq/.local/bin/hex dictation stop"
)

-- Change the keybinds — use Flea instead of Files as the default file manager
hl.unbind "SUPER + SHIFT + F"
o.bind("SUPER + SHIFT + F", "File manager", { launch = "flea --gui" })
hl.unbind "SUPER + ALT + SHIFT + F"
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { launch = 'flea --gui "$(omarchy-cmd-terminal-cwd)"' })
-- Make flea the default file picker
o.window("com.thisisgm.flea.picker", { tag = "+floating-window" })
