-- workspace.lua
-- Rewritten for the new hl.* Lua config API.
-- hl.window_rule({...}) call per rule.
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
    name  = "ws2-zen",
    match = { class = "^(zen)$" },
    workspace = "2",
})

hl.window_rule({
    name  = "ws4-nemo",
    match = { class = "^(nemo)$" },
    workspace = "4",
})

hl.window_rule({
    name  = "ws3-code",
    match = { class = "^(code)$" },
    workspace = "3",
})

hl.window_rule({
    name  = "ws3-evince",
    match = { class = "^(evince)$" },
    workspace = "3",
})

hl.window_rule({
    name  = "ws3-pip",
    match = { title = "^(Picture-in-Picture)$" },
    workspace = "3",
})

hl.window_rule({
    name  = "ws4-xed",
    match = { class = "^(xed)$" },
    workspace = "4",
})

hl.window_rule({
    name  = "ws5-gnome-calendar",
    match = { class = "^(gnome-calendar)$" },
    workspace = "5",
})

hl.window_rule({
    name  = "ws6-obsidian",
    match = { class = "^(obsidian)$" },
    workspace = "6",
})

hl.window_rule({
    name  = "ws8-btop-monitor",
    match = { class = "^(custombtoplauncher)$" },
    workspace = "8",
})

hl.window_rule({
    name  = "ws10-mpv",
    match = { class = "^(mpv)$" },
    workspace = "10",
})

hl.window_rule({
    name  = "exit-hyprland-pass",
    match = { title = "^(Exit-hyprland-pass)$" },

    float    = true,
    center   = true,
    size     = "800 100",
    no_anim  = true,
})
