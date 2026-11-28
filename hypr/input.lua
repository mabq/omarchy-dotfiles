-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config {
  input = {
    -- For keyboard layouts, variants and options read the file
    --  `/usr/share/X11/xkb/rules/evdev.lst`.

    -- Same layout, two variants. Use `super + i` to cycle through configured
    -- input methods.
    kb_layout = "us,us",
    kb_variant = ",intl",

    -- Omarchy uses Capslock as the compose key. I prefer to completely disable
    -- the capslock key by remaping it to Ctrl with keyd (accidentally enabling
    -- capslock can be very confusing in Neovim). Use ralt as compose key
    -- instead, it is available in any keyboard (I also provide an easier
    -- keybind with keyd).
    kb_options = "compose:ralt",

    -- Change speed of keyboard repeat
    repeat_rate = 40,
    repeat_delay = 250,

    -- Start with numlock on by default
    numlock_by_default = true,

    -- scroll_factor = 1,
  },
}

-- App-specific touchpad scroll speeds.
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Enable touchpad gestures for changing workspaces.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Enable touchpad gestures for moving focus (helpful on scrolling layout).
-- hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
-- hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
