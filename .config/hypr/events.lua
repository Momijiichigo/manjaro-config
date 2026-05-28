hl.on(
    "hyprland.start",
    function()
        local BatteryWarned = {None=0, Low=1, Critical=2}
        local battery_warned = BatteryWarned.None

        hl.timer(
            function()
                local pct_handle = io.popen("upower -i $(upower -e | rg 'BAT') | rg ' +percentage: +(\\d+)%$' -r '$1'")
                local state_handle = io.popen("upower -i $(upower -e | rg 'BAT') | rg ' +state: +(.+)$' -r '$1'")

                local pct_str = pct_handle and pct_handle:read("*l")
                if pct_handle then pct_handle:close() end
                local state_str = state_handle and state_handle:read("*l")
                if state_handle then state_handle:close() end

                local pct = tonumber(pct_str)
                local state = state_str and state_str:match("^%s*(.-)%s*$")

                if not pct then return end

                if pct >= 20 then
                    battery_warned = BatteryWarned.None
                elseif state == "discharging" then
                    if pct < 10 and battery_warned ~= BatteryWarned.Critical then
                        hl.exec_cmd('notify-send --icon battery-empty "Battery Critical" "Battery is critically low, please plug in the charger"')
                        battery_warned = BatteryWarned.Critical
                    elseif battery_warned == BatteryWarned.None then
                        hl.exec_cmd('notify-send --icon battery "Battery Low" "Battery is low, please plug in the charger"')
                        battery_warned = BatteryWarned.Low
                    end
                end
            end,
            {
                timeout = 120000,
                type = "repeat"
            }
        )
    end

)

hl.on(
    "monitor.added",
    ---@param monitor HL.Monitor
    function (monitor)
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
)


hl.on(
    "monitor.removed",
    ---@param monitor HL.Monitor
    function (monitor)
        hl.exec_cmd(
            "eww close bar_" .. monitor.name
        )

        hl.exec_cmd(
            "eww close wallpaper_clock_" .. monitor.name
        )
    end
)


local function set_eww_wspaces()
    local monitor_workspaces = {}
    local max_idx = -1

    for _, ws in ipairs(hl.get_workspaces()) do
        if ws.monitor and not ws.special then
            local mid = ws.monitor.id
            monitor_workspaces[mid] = monitor_workspaces[mid] or {}
            table.insert(monitor_workspaces[mid], ws.id)
            if mid > max_idx then max_idx = mid end
        end
    end

    local parts = {}
    for i = 0, max_idx do
        local ws = monitor_workspaces[i]
        if ws then
            table.sort(ws)
            table.insert(parts, "[" .. table.concat(ws, ",") .. "]")
        else
            table.insert(parts, "[]")
        end
    end

    hl.exec_cmd('eww update wspaces=[' .. table.concat(parts, ",") .. ']')
end


hl.on("workspace.created",
    function ()
        set_eww_wspaces()
    end
)
hl.on("workspace.removed",
    function ()
        set_eww_wspaces()
    end
)
hl.on("workspace.active",
    ---@param workspace HL.Workspace
    function (workspace)
        hl.exec_cmd("eww update current_workspace=" .. workspace.id)
    end
)


hl.on("window.move_to_workspace",
    ---@param window HL.Window
    ---@param workspace HL.Workspace
    function (window, workspace)
        set_eww_wspaces()
        hl.exec_cmd("eww update current_workspace=" .. workspace.id)
    end
)

hl.on("window.open",
    ---@param window HL.Window
    function(window)
        set_eww_wspaces()
    end
)

-- hl.on("window.urgent",
--     ---@param window HL.Window
--     function(window)
--       hl.dsp.focus({ window = window })
--       hl.exec_cmd("notify-send ".. window.title)
--
--     end
-- )
