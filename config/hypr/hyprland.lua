-- monitor=,preferred,auto,auto
-- See https://wiki.hyprland.org/Configuring/Keywords/ for more

-- Execute your favorite apps at launch
-- exec-once = waybar & hyprpaper & firefox


-- Source a file (multi-file configs)
-- source = ~/.config/hypr/myColors.conf

-- Set programs that you use
local editor = "vim" -- nano
local terminal = "gnome-terminal" -- kitty
local fileManager = "nemo" -- nautilus
local menu = "wofi --show drun" -- wofi -show drun

-- Some default env vars.
env = {
    "XCURSOR_SIZE,24",
    "QT_QPA_PLATFORMTHEME,qt5ct", -- change to qt6ct if you have that
}

-- For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    follow_mouse = 1,

    touchpad = {
        natural_scroll = false,
    },

    sensitivity = 0, -- -1.0 to 1.0, 0 means no modification.
}

general = {
    -- See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 1,
    gaps_out = 1,
    
    border_size = 1,
    ["col.active_border"] = "rgb(8c8c8c)", 

    layout = "dwindle",

    -- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false,
}

decoration = {
    -- See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 0,
    
    blur = {
        enabled = true,
        size = 3,
        passes = 1,
    },
    inactive_opacity = 0.5, -- Range is 0.0 to 1.0
    drop_shadow = true,
    shadow_range = 4,
    shadow_render_power = 3,
    ["col.shadow"] = "rgba(1a1a1aee)",
}

animations = {
    enabled = false,

    -- Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = { "myBezier, 0.05, 0.9, 0.1, 1.05" },

    animation = {
        "windows, 1, 7, myBezier",
        "windowsOut, 1, 7, default, popin 80%",
        "border, 1, 10, default",
        "borderangle, 1, 8, default",
        "fade, 1, 7, default",
        "workspaces, 1, 6, default",
    },
}

dwindle = {
    -- See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = true, -- master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true, -- you probably want this
}

-- master = {
--     -- See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
--     new_is_master = true
-- }

-- gestures = {
--     -- See https://wiki.hyprland.org/Configuring/Variables/ for more
--     workspace_swipe = false
-- }

misc = {
    -- See https://wiki.hyprland.org/Configuring/Variables/ for more
    force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
}

-- Example per-device config
-- See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
device = {
    {
        name = "epic-mouse-v1",
        sensitivity = -0.5,
    },
}

-- Example windowrule v1
-- windowrule = "float, ^(kitty)$"
-- Example windowrule v2
-- windowrulev2 = "float,class:^(kitty)$,title:^(kitty)$"

-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
windowrulev2 = { "suppressevent maximize, class:.*" } -- You'll probably like this.

source = {
    os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/config/hypr/workspace.lua",
}

-- Executed acommands 
exec_once = {
    'swaybg -i "$CURRENT_WALLPAPER" -m fill',
    "swaync",
    "waybar",
    "hypridle",
    "custombtoplancher",
    "custombrightnessctl resetToDefault",
}

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more

-- Mod keys [i dont like to use capitalized SUPER<SHIFT<ALT<CTRL it sounds like im screeming some jutsu like "SUPER+T" i summong btop-moniter]
local mainMod = "SUPER"
local shiftMod = "SHIFT"
local altMod = "ALT"
local ctrlMod = "CTRL"

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = {
    ------------------- APPLICATIONS -----------------

    mainMod .. ", RETURN, exec, " .. terminal, -- Launch Terminal
    ", code:118, exec, hyprlock", -- Lock Screen with the ScrLK key
    mainMod .. ", T, exec, custombtoplancher", -- Launch Btop (custom)

    mainMod .. " " .. shiftMod .. ", V, exec, code", -- Launch VSCode 
    mainMod .. " " .. shiftMod .. ", O, exec, obsidian", -- Launch Obsidian
    mainMod .. " " .. shiftMod .. ", F, exec, zen", -- Launch Zen Browser

    mainMod .. " " .. shiftMod .. ", E, exec, " .. fileManager, -- Launch File Manager


    mainMod .. ", S, exec, customwallpaperswitcher + ",
    mainMod .. " " .. shiftMod .. ", S, exec, customwallpaperswitcher - ",
   
    -- ----------------- WEB-APP FILE SOURCE ----------------
   
    table.insert(source, os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/config/hypr/webappsbinds.lua")
   
    ------------------- WINDOW CONTROL -----------------

    mainMod .. ", C, killactive", -- Close active window
    mainMod .. ", X, togglefloating", -- Toggle floating
    mainMod .. ", P, pseudo", -- Dwindle pseudo
    mainMod .. ", J, togglesplit", -- Dwindle split toggle
    mainMod .. ", SPACE, exec, " .. menu, -- Launch app launcher
    mainMod .. ", Escape, exec, customhyprlandexit", -- Logout script
    mainMod .. " " .. shiftMod .. ", Escape, exit,", -- Logging out of the hyprland WM and not the system it self

    ctrlMod .. " " .. mainMod .. ", T, exec, customwofisearch", -- Launch wofi with custom style

    ------------------- CONFIG EDITING -----------------

    mainMod .. " " .. shiftMod .. ", H, exec, " .. terminal .. ' --title="hyprlandConfig" --command="' .. editor .. ' ' .. os.getenv("HOME") .. '/.local/share/LinuxMintHyprlandConfig/config/hypr/hyprland.conf"',
    mainMod .. " " .. shiftMod .. ", W, exec, " .. terminal .. ' --title="waybarConfig" --command="' .. editor .. ' ' .. os.getenv("HOME") .. '/.local/share/LinuxMintHyprlandConfig/config/waybar/config.jsonc"',

    -- ----------------- MEDIA KEYS -----------------

    ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+",
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",

    ctrlMod .. ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+",
    ctrlMod .. ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-",

    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",

    ", code:127, exec, bash " .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/config/hypr/configScripts/playerctl-toggle.sh", -- to use it as a globle audio/video controll, this key code:127 is the pause key

    shiftMod .. ", code:127, exec, bash " .. os.getenv("HOME") .. "/.local/share/LinuxMintHyprlandConfig/config/hypr/configScripts/playerctl-previous.sh", -- to use it as a globle audio/video controll, this is replay the previous song  

    -- --------------- Brightness Controll ----------
    ctrlMod .. " " .. shiftMod .. ", B, exec, custombrightnessctl + 5",
    ctrlMod .. ", B, exec,  custombrightnessctl - 5",

    --Screen_Shot_Bindes from hyprshot git.
    ", PRINT, exec, hyprshot -m output",
    mainMod .. ", PRINT, exec, hyprshot -m window ",
    shiftMod .. ", PRINT, exec, hyprshot -m region",


    -- Move focus with mainMod + arrow keys
    mainMod .. ", left, movefocus, l",
    mainMod .. ", right, movefocus, r",
    mainMod .. ", up, movefocus, u",
    mainMod .. ", down, movefocus, d",
    --mainMod .. ", Tab, cyclenext", -- Change focus to another window

    -- movewindow with arrow keys
    mainMod .. " " .. ctrlMod .. ", left, movewindow, l",
    mainMod .. " " .. ctrlMod .. ", down, movewindow, d",
    mainMod .. " " .. ctrlMod .. ", up, movewindow, u",
    mainMod .. " " .. ctrlMod .. ", right, movewindow, r",

    -- movewindow with arrow keys
    --ctrlMod .. ", left,  exec, wlrctl pointer move -30 0",
    --ctrlMod .. ", right, exec, wlrctl pointer move 30 0",
    --ctrlMod .. ", up,    exec, wlrctl pointer move 0 -30",
    --ctrlMod .. ", down,  exec, wlrctl pointer move 0 30",

    --mainMod .. " code:23, left,  exec, wlrctl pointer move -1 0",
    --mainMod .. " code:23, right, exec, wlrctl pointer move 1 0",
    --mainMod .. " code:23, up,    exec, wlrctl pointer move 0 -1",
    --mainMod .. " code:23, down,  exec, wlrctl pointer move 0 1",

    --ctrlMod .. " Z, exec, wlrctl pointer click left",
    --ctrlMod .. " X, exec, wlrctl pointer click right",

    -- Switch workspaces with mainMod + [0-9]
    mainMod .. ", 1, workspace, 1",
    mainMod .. ", 2, workspace, 2",
    mainMod .. ", 3, workspace, 3",
    mainMod .. ", 4, workspace, 4",
    mainMod .. ", 5, workspace, 5",
    mainMod .. ", 6, workspace, 6",
    mainMod .. ", 7, workspace, 7",
    mainMod .. ", 8, workspace, 8",
    mainMod .. ", 9, workspace, 9",
    mainMod .. ", 0, workspace, 10",

    -- Move active window to a workspace with mainMod + shiftMod + [0-9]
    mainMod .. " " .. shiftMod .. ", 1, movetoworkspace, 1",
    mainMod .. " " .. shiftMod .. ", 2, movetoworkspace, 2",
    mainMod .. " " .. shiftMod .. ", 3, movetoworkspace, 3",
    mainMod .. " " .. shiftMod .. ", 4, movetoworkspace, 4",
    mainMod .. " " .. shiftMod .. ", 5, movetoworkspace, 5",
    mainMod .. " " .. shiftMod .. ", 6, movetoworkspace, 6",
    mainMod .. " " .. shiftMod .. ", 7, movetoworkspace, 7",
    mainMod .. " " .. shiftMod .. ", 8, movetoworkspace, 8",
    mainMod .. " " .. shiftMod .. ", 9, movetoworkspace, 9",
    mainMod .. " " .. shiftMod .. ", 0, movetoworkspace, 10",

    -- Example special workspace (scratchpad)
    -- mainMod .. ", S, togglespecialworkspace, magic",
    -- mainMod .. " " .. shiftMod .. ", S, movetoworkspace, special:magic",

    -- Scroll through existing workspaces with mainMod + scroll
    mainMod .. ", mouse_down, workspace, e+1",
    mainMod .. ", mouse_up, workspace, e-1",
}

bindm = {
    -- Move/resize windows with mainMod + LMB/RMB and dragging
    mainMod .. ", mouse:272, movewindow",
    mainMod .. ", mouse:273, resizewindow",
}

binde = {
    -- Move/resize windows with mainMod with keys like mainMod+shiftMod
    mainMod .. " " .. shiftMod .. ", right, resizeactive, 40 0",
    mainMod .. " " .. shiftMod .. ", left,  resizeactive, -40 0",
    mainMod .. " " .. shiftMod .. ", up,    resizeactive, 0 -40",
    mainMod .. " " .. shiftMod .. ", down,  resizeactive, 0 40",

    -- Move the window in free state with keys like mainMod+shiftMod
    mainMod .. ", l, moveactive, 40 0",
    mainMod .. ", h, moveactive, -40 0",
    mainMod .. ", j, moveactive, 0 -40",
    mainMod .. ", k, moveactive, 0 40",
}