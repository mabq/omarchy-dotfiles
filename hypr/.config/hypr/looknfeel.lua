-- For defaults see /etc/skel/.config/hypr

hl.config {
  general = {
    gaps_out = 3,
    gaps_in = 2,
    layout = "scrolling",
  },
}

-- Do not animate transisions between fullscreen windows
hl.window_rule {
  match = { fullscreen = true },
  no_anim = true,
}

-- Opt another application in to Omarchy's standard transparency.
-- Find its class with: hyprctl clients
-- o.transparent_window("my-app")
-- o.transparent_window("my-app", "0.9 0.85") -- Custom active/inactive opacity.
