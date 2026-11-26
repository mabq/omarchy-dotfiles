-- For defaults see /etc/skel/.config/hypr

hl.config {
  general = {
    gaps_out = 0,
    gaps_in = 0,

    no_focus_fallback = false,
  },

  binds = {
    -- Disable this to move between monitors, enable it to allow focus change
    -- from a fullscreen window.
    -- movefocus_cycles_fullscreen = true,
  },

  scrolling = {
    focus_fit_method = 0, -- center window when focused
  },
}

hl.animation { leaf = "specialWorkspaceIn", enabled = 0 }
hl.animation { leaf = "specialWorkspaceOut", enabled = 0 }

-- No gaps when there's only one visible tiled window (or a maximized one)
-- hl.workspace_rule {
--   workspace = "w[tv1]s[false]",
--   border_size = 0,
-- }

-- E.g. No border for specic apps
-- hl.window_rule {
--   name = "no-brave-border",
--   match = { class = "brave-browser", float = false },
--   border_size = 0,
-- }

--

-- Opt another application in to Omarchy's standard transparency.
-- Find its class with: hyprctl clients
-- o.transparent_window("my-app")
-- o.transparent_window("my-app", "0.9 0.85") -- Custom active/inactive opacity.
