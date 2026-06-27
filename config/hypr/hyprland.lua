-- ============================================================
-- hyprland.lua
-- Rewritten to use ONLY the new hl.* Lua config API.
-- See https://wiki.hypr.land/Configuring/Start/
-- ============================================================


---------------------
---- MY PROGRAMS ----
---------------------

local editor      = "vim"            -- nano
local terminal     = "gnome-terminal" -- kitty
local fileManager   = "nemo"           -- nautilus
local menu          = "wofi --show drun"

local mainMod  = "SUPER"
local shiftMod = "SHIFT"
local altMod   = "ALT"
local ctrlMod  = "CTRL"

local HOME = os.getenv("HOME")


------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct") -- change to qt6ct if that's what you use


-------------------
---- AUTOSTART ----
-------------------

-- This is the critical fix: in the old config this was a dead
-- `exec_once = {...}` table. In the new API you must register a
-- "hyprland.start" callback and explicitly call hl.exec_cmd for
-- each program. This is what actually launches waybar, your
-- wallpaper daemon, notifications, idle daemon, etc. on login.
hl.on("hyprland.start", function()
    hl.exec_cmd('swaybg -i "$CURRENT_WALLPAPER" -m fill')
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("custombtoplauncher")
    hl.exec_cmd("custombrightnessctl resetToDefault")
    hl.exec_cmd("swaync")
end)


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 1,
        gaps_out = 1,

        border_size = 1,

        col = {
            active_border = "rgb(8c8c8c)",
        },

        layout = "dwindle",

        -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/
        allow_tearing = false,
    },

    decoration = {
        rounding = 0,

        inactive_opacity = 0.5, -- 0.0 - 1.0

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled = true,
            size    = 3,
            passes  = 1,
        },
    },

    animations = {
        enabled = true,
    },
})

-- new curve/animation API.
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",    enabled = true, speed = 2, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "borderangle",enabled = true, speed = 2,  bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 2,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2,  bezier = "default" })


-------------------
---- DWINDLE -----
-------------------

hl.config({
    dwindle = {
--         pseudotile     = true, -- master switch for pseudotiling (mainMod + P below)
        preserve_split = true,
    },
})

-- Master layout (left commented, same as your original)
-- hl.config({
--     master = {
--         new_status = "master",
--     },
-- })

-- Gestures (workspace swipe replacement) -- left available, commented
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 to 1.0, 0 = no modification

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Example per-device config
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


--------------------------------
---- WINDOW RULES ----
--------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})


----------------------------------
---- SOURCED / REQUIRED FILES ----
----------------------------------

package.path = package.path .. ";" .. HOME .. "/.local/share/LinuxMintHyprlandConfig/config/hypr/?.lua"

local function safe_require(mod)
    local ok, err = pcall(require, mod)
    if not ok then
        hl.exec_cmd('notify-send "Hyprland config" "Failed to load --hint=boolean:transient:true ' .. mod .. ': ' .. tostring(err):gsub('"','\\"') .. '"')
    end
end

safe_require("workspace")
safe_require("webappsbinds")


---------------------
---- KEYBINDINGS ----
---------------------
-- NOTE: hl.bind() takes ONE combined "MOD + MOD + KEY" string as its
-- first argument (e.g. "SUPER + SHIFT + V"), not separate mod/key
-- arguments. See https://wiki.hypr.land/Configuring/Basics/Binds/

-- ---- Applications ----
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind("code:118", hl.dsp.exec_cmd("hyprlock")) -- ScrLk to lock
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("custombtoplauncher"))

hl.bind(mainMod .. " + " .. shiftMod .. " + V", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + " .. shiftMod .. " + O", hl.dsp.exec_cmd("obsidian"))
hl.bind(mainMod .. " + " .. shiftMod .. " + F", hl.dsp.exec_cmd("zen"))
hl.bind(mainMod .. " + " .. shiftMod .. " + E", hl.dsp.exec_cmd(fileManager))

hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("customwallpaperswitcher +"))
hl.bind(mainMod .. " + " .. shiftMod .. " + S", hl.dsp.exec_cmd("customwallpaperswitcher -"))

-- ---- Window control ----
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + X", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("customhyprlandexit"))
hl.bind(mainMod .. " + " .. shiftMod .. " + Escape", hl.dsp.exit())

hl.bind(ctrlMod .. " + " .. mainMod .. " + T", hl.dsp.exec_cmd("customwofisearch"))

-- ---- Config editing shortcuts ----
hl.bind(mainMod .. " + " .. shiftMod .. " + H",
    hl.dsp.exec_cmd(terminal .. ' --title="hyprlandConfig" --command="' .. editor .. ' ' .. HOME .. '/.local/share/LinuxMintHyprlandConfig/config/hypr/hyprland.lua"'))
hl.bind(mainMod .. " + " .. shiftMod .. " + W",
    hl.dsp.exec_cmd(terminal .. ' --title="waybarConfig" --command="' .. editor .. ' ' .. HOME .. '/.local/share/LinuxMintHyprlandConfig/config/waybar/config.jsonc"'))

-- ---- Media keys ----
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })

hl.bind(ctrlMod .. " + XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+"), { repeating = true })
hl.bind(ctrlMod .. " + XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"), { repeating = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-- Pause key used as a global media toggle (code:127)
hl.bind("code:127", hl.dsp.exec_cmd("bash " .. HOME .. "/.local/share/LinuxMintHyprlandConfig/config/hypr/configScripts/playerctl-toggle.sh"))
hl.bind(shiftMod .. " + code:127", hl.dsp.exec_cmd("bash " .. HOME .. "/.local/share/LinuxMintHyprlandConfig/config/hypr/configScripts/playerctl-previous.sh"))

-- ---- Brightness control ----
hl.bind(ctrlMod .. " + " .. shiftMod .. " + B", hl.dsp.exec_cmd("custombrightnessctl + 5"))
hl.bind(ctrlMod .. " + B", hl.dsp.exec_cmd("custombrightnessctl - 5"))

-- ---- Screenshots (hyprshot) ----
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(shiftMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))

-- ---- Move focus with mainMod + arrow keys ----
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- ---- Move window with mainMod + CTRL + arrow keys ----
hl.bind(mainMod .. " + " .. ctrlMod .. " + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + " .. ctrlMod .. " + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + " .. ctrlMod .. " + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + " .. ctrlMod .. " + right", hl.dsp.window.move({ direction = "right" }))

-- ---- Switch workspaces with mainMod + [0-9] ----
-- ---- Move active window to a workspace with mainMod + SHIFT + [0-9] ----
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. tostring(key), hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + " .. shiftMod .. " + " .. tostring(key), hl.dsp.window.move({ workspace = i }))
end

-- ---- Scroll through workspaces with mainMod + mouse wheel ----
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- ---- Move/resize windows with mainMod + LMB/RMB drag ----
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ---- Resize active window with mainMod + SHIFT + arrow keys (repeating) ----
hl.bind(mainMod .. " + " .. shiftMod .. " + right", hl.dsp.window.resize({ x = 40,  y = 0,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + " .. shiftMod .. " + left",  hl.dsp.window.resize({ x = -40, y = 0,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + " .. shiftMod .. " + up",    hl.dsp.window.resize({ x = 0,   y = -40, relative = true }), { repeating = true })
hl.bind(mainMod .. " + " .. shiftMod .. " + down",  hl.dsp.window.resize({ x = 0,   y = 40,  relative = true }), { repeating = true })

-- ---- Move floating window with mainMod + h/j/k/l (repeating) ----
hl.bind(mainMod .. " + l", hl.dsp.window.move({ x = 40,  y = 0,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + h", hl.dsp.window.move({ x = -40, y = 0,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + j", hl.dsp.window.move({ x = 0,   y = -40, relative = true }), { repeating = true })
hl.bind(mainMod .. " + k", hl.dsp.window.move({ x = 0,   y = 40,  relative = true }), { repeating = true })
