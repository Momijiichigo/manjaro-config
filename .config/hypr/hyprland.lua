-- Hyprland Lua Configuration
-- Ported from hyprland.conf

local hotkey_parser = require("hotkey_parser")
require("events")

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "desc:Dell Inc. DELL S2721QS GQ9MM43",
    mode     = "preferred",
    position = "auto-left",
    scale    = "auto",
})

hl.monitor({
    output = "desc:HKC OVERSEAS LIMITED 24N1A 0000000000001",
    mode   = "preferred",
    position = "auto-left",
    scale  = "auto",
})

hl.config({
    xwayland = {
        force_zero_scaling = true
    }
})

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
    hl.exec_cmd("swaync")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("eww daemon")
    -- hl.exec_cmd("~/.config/eww/launch_bar")
    -- hl.exec_cmd("bun run ~/.config/hypr/scripts/index.ts main")
    hl.exec_cmd("fcitx5-remote")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("copyq")
    hl.exec_cmd("slimbookbattery --minimize")



    hl.timer(
        function()
            for _, monitor in ipairs(hl.get_monitors()) do
                hl.exec_cmd(
                    "eww open-many bar:bar_"
                    .. monitor.name
                    .. " --arg bar_"
                    .. monitor.name
                    .. ":screen="
                    .. monitor.id
                )

                hl.exec_cmd(
                    "eww open-many wallpaper_clock:wallpaper_clock_"
                    .. monitor.name
                    .. " --arg wallpaper_clock_"
                    .. monitor.name
                    .. ":screen="
                    .. monitor.id
                )
            end
            hl.exec_cmd("bun run ~/.config/eww/scripts/wifi/index.ts main")
            hl.exec_cmd("bun run ~/.config/eww/scripts/music/index.ts main")
        end,
        {
            timeout = 300,
            type = "oneshot"
        }
    )

    hl.timer(
        function()
            hl.exec_cmd("bun run ~/.config/eww/scripts/swaync/index.ts main")
        end,
        {
            timeout = 5000,
            type = "oneshot"
        }
    )

end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("GDK_SCALE", "2")

hl.env("AQ_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card0")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 3,
        border_size = 2,
        col = {
            active_border = { colors = {"rgba(4ccdd4ee)", "rgba(49d19bee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = true,
    },

    decoration = {
        rounding = 7,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        blur = {
            enabled = true,
            size = 4,
            passes = 2,
            vibrancy = 0.1696,
        },
    },

    group = {
        col = {
            border_active = "rgba(4ccdd4ee)",
            border_inactive = "rgba(808080ee)",
        },
        groupbar = {
            enabled = true,
            height = 0,
            rounding = 4,
            indicator_height = 3,
            col = {
                active = "rgba(4ccdd4ee)",
                inactive = "rgba(808080ee)",
            }
        }
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    }
})

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",       enabled = true, speed = 2, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 2, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",        enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "borderangle",   enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade",          enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 2, bezier = "default" })

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "us",
        kb_options = "compose:ins",
        repeat_rate = 50,
        repeat_delay = 300,
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            scroll_factor = 0.5,
        },
        tablet = {
            output = "current",
        }
    }
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })

hl.window_rule({
    name = "no-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding = 0,
})

hl.window_rule({
    name = "no-gaps-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding = 0,
})

hl.window_rule({ name = "float-nm", match = { initial_class = "nm-connection-editor" }, float = true })
hl.window_rule({ name = "float-share-picker", match = { initial_class = "hyprland-share-picker" }, float = true })
hl.window_rule({ name = "float-msedge-app", match = { initial_class = "msedge-_idgadaccgipmpannjkmfddolnnhmeklj-Default" }, float = true })

hl.window_rule({
    name = "ueberzug",
    match = { initial_class = ".*ueberzug.*" },
    content = "photo",
    float = true,
    no_focus = true,
    no_blur = true,
    no_anim = true,
    opaque = true,
    border_size = 0,
    rounding = 0,
    center = false,
})

hl.window_rule({
    name = "float-utils",
    match = { initial_class = "^float$" },
    float = true,
    size = "900 300",
    center = true
})

hl.window_rule({
    name = "chromium-pic-in-pic",
    match = { initial_title = "Picture in picture" },
    pin = true,
    float = true,
    content = "video",
    size = "400 300",
    decorate = false
})

hl.window_rule({
    name = "float-emoji-picker",
    match = { initial_class = "^org.kde.plasma.emojier$" },
    float = true,
    size = "900 300",
    center = true
})

hl.window_rule({
    name = "copyq",
    match = { initial_class = "com.github.hluk.copyq" },
    float = true,
    size = "600 700",
    center = true
})

hl.window_rule({
    name = "nmtui-window",
    match = { initial_class = "^nmtui$" },
    float = true,
    size = "600 700",
    center = true
})

hl.window_rule({
    name = "thunar",
    match = { initial_class = "[Tt]hunar" },
    float = true,
    size = "750 600"
})

hl.window_rule({
    name = "thunar-rename",
    match = { initial_class = "[Tt]hunar", initial_title = "^Rename .*" },
    float = true,
    size = "400 100"
})

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize"
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false
    },
    no_focus = true
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true
})

-- Layer rules
hl.layer_rule({ name = "blur-gtk-shell", match = { namespace = "gtk-layer-shell" }, blur = true })
hl.layer_rule({ name = "blur-eww", match = { namespace = "^(eww-blur)$" }, blur = true })
hl.layer_rule({ name = "blur-rofi", match = { namespace = "^(rofi)$" }, blur = true })
hl.layer_rule({ name = "blur-swaync", match = { namespace = "swaync-control-center" }, blur = true })

---------------------
---- KEYBINDINGS ----
---------------------

hotkey_parser.parse_and_bind(hotkey_parser.path_resolve("./hotkeys.conf"))
