-- Read
--   Omarchy  Guide: https://omarchy.org/manual/monitors/
--   Hyprland Guide: https://wiki.hypr.land/Configuring/Basics/Monitors/
--
-- List current monitors and supported resolutions with: `hyprctl monitors all`

local omarchy_gdk_scale = 2 -- integers only!, must reopen to take effect
local omarchy_monitor_scale = 2

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Default config
hl.monitor { output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale }

-- Per-monitor config
hl.monitor { output = "DP-1", mode = "preferred", position = "auto", scale = 1 }
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 }) -- transform: 1 = 90°, 3 = 270°
