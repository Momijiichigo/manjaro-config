local M = {}

-- Utility to trim strings
local function trim(s)
    if not s then return "" end
    return s:match("^%s*(.-)%s*$")
end

-- Utility to split strings by semicolon
local function split_semicolon(s)
    local res = {}
    for part in s:gmatch("([^;]+)") do
        table.insert(res, trim(part))
    end
    return res
end

-- Utility to split strings by comma
local function split_comma(s)
    local res = {}
    for part in s:gmatch("([^,]+)") do
        table.insert(res, trim(part))
    end
    return res
end

-- Utility to resolve relative paths
local function path_resolve(path)
    if not path:find("^%.") then return path end

    local handle = io.popen("pwd")
    if not handle then return path end

    local pwd_raw = handle:read("*a")
    handle:close()
    if not pwd_raw then return path end
    local pwd = pwd_raw:gsub("%s+$", "")

    if path:find("^%./") then
        return pwd .. "/.config/hypr/" .. path:sub(3)
    elseif path:find("^%.%./") then
        return pwd .. "/.config/" .. path:sub(3)
    end
    return path
end

-- Bracket expansion logic (handles [a; b; c], [a, b, c] and [_])
-- {} is reserved for Lua table literals in command args
local function expand_braces(line)
    local results = { line }
    local has_expansion = true

    while has_expansion do
        has_expansion = false
        local new_results = {}

        for _, current_line in ipairs(results) do
            local open_bracket = current_line:find("%[")
            local close_bracket = current_line:find("%]")

            if open_bracket and close_bracket and close_bracket > open_bracket then
                has_expansion = true
                local before = current_line:sub(1, open_bracket - 1)
                local after = current_line:sub(close_bracket + 1)
                local inner = current_line:sub(open_bracket + 1, close_bracket - 1)

                local parts
                if inner:find(";") then
                    parts = split_semicolon(inner)
                else
                    parts = split_comma(inner)
                end

                for _, part in ipairs(parts) do
                    if part == "_" then
                        table.insert(new_results, before .. after)
                    else
                        table.insert(new_results, before .. part .. after)
                    end
                end
            else
                table.insert(new_results, current_line)
            end
        end
        results = new_results
    end

    return results
end

-- Handle numeric ranges like [1-9] or mixed like [1-9;0]
local function expand_ranges(input)
    return input:gsub("%[(.-)%]", function(inner)
        local expanded_parts = {}
        -- Only split by ; for ranges
        for part in inner:gmatch("([^;]+)") do
            local p = trim(part)
            local start_n, end_n = p:match("^(%d+)%-(%d+)$")
            if start_n and end_n then
                for i = tonumber(start_n), tonumber(end_n) do
                    table.insert(expanded_parts, tostring(i))
                end
            else
                table.insert(expanded_parts, p)
            end
        end
        return "[" .. table.concat(expanded_parts, "; ") .. "]"
    end)
end

-- Helper for move_win logic (ported from move_win.sh)
function M.move_win(args)
    local dir = type(args) == "table" and args.direction or args

    local w = hl.get_active_window()
    if not w then return end

    -- Handle list if returned
    if w[1] then w = w[1] end

    if w.floating then
        local x, y = 0, 0
        if dir == "left" then x = -30
        elseif dir == "down" then y = 30
        elseif dir == "up" then y = -30
        elseif dir == "right" then x = 30
        end
        -- Try move_active for floating windows
        local dispatcher = hl.dsp.window.move({ x = x, y = y, relative=true })
        hl.dispatch(dispatcher)
    else
        hl.dispatch(hl.dsp.window.move({ direction = dir }))
    end
end

function M.move_win_in_out_group(args)
    local dir = type(args) == "table" and args.direction or args

    local w = hl.get_active_window()
    if not w then return end

    -- Handle list if returned
    if w[1] then w = w[1] end

    if w.group then
        hl.dispatch(hl.dsp.window.move({ out_of_group = dir }))
    else
        hl.dispatch(hl.dsp.window.move({ into_or_create_group = dir }))
    end
end

function M.toggle_trackpad_while_typing()
    local updated_val = not hl.get_config('input.touchpad.disable_while_typing')
    hl.config({
        input = {
            touchpad = {
                disable_while_typing = updated_val
            }
        }
    })
    hl.exec_cmd("swayosd-client --custom-message='Trackpad " .. (updated_val and "OFF" or "ON") .. " while key-typing'")
end

-- Helper to resolve nested table paths like "window.resize" in hl.dsp
local function resolve_path(root, path)
    if not root or not path then return nil end
    local current = root
    for part in path:gmatch("[^%.]+") do
        if type(current) ~= "table" then return nil end
        current = current[part]
    end
    return current
end

-- Split args string by commas, respecting {} nesting
local function split_args(args_str)
    local parts = {}
    local depth = 0
    local current = ""
    for i = 1, #args_str do
        local c = args_str:sub(i, i)
        if c == "{" then
            depth = depth + 1
            current = current .. c
        elseif c == "}" then
            depth = depth - 1
            current = current .. c
        elseif c == "," and depth == 0 then
            table.insert(parts, current)
            current = ""
        else
            current = current .. c
        end
    end
    if current ~= "" then table.insert(parts, current) end
    return parts
end

local function coerce_value(v)
    if v == "true" then return true
    elseif v == "false" then return false
    elseif tonumber(v) then return tonumber(v)
    else return v:match("^['\"]?(.-)['\"]?$") end
end

-- Helper to parse "key1=val1, key2=val2" or "{ key1=val1, key2=val2 }" into a table
local function parse_args_table(args_str)
    local t = {}
    if not args_str or args_str == "" then return t end

    -- Strip outer {} Lua table literal: { ... }
    local inner = args_str:match("^%s*{(.*)}%s*$")
    if inner then args_str = inner end

    for _, pair in ipairs(split_args(args_str)) do
        local k, v = pair:match("^%s*([%w_%.]+)%s*=%s*(.-)%s*$")
        if k and v then
            -- Value may itself be a Lua table literal {k=v, ...}
            local tbl_inner = v:match("^{(.*)}$")
            if tbl_inner then
                local sub = {}
                for _, sub_pair in ipairs(split_args(tbl_inner)) do
                    local sk, sv = sub_pair:match("^%s*([%w_%.]+)%s*=%s*(.-)%s*$")
                    if sk and sv then sub[sk] = coerce_value(sv) end
                end
                t[k] = sub
            else
                t[k] = coerce_value(v)
            end
        else
            local val = trim(pair)
            -- Positional Lua table literal {k=v, ...}
            local tbl_inner = val:match("^{(.*)}$")
            if tbl_inner then
                local sub = {}
                for _, sub_pair in ipairs(split_args(tbl_inner)) do
                    local sk, sv = sub_pair:match("^%s*([%w_%.]+)%s*=%s*(.-)%s*$")
                    if sk and sv then sub[sk] = coerce_value(sv) end
                end
                table.insert(t, sub)
            elseif val ~= "" then
                table.insert(t, coerce_value(val))
            end
        end
    end
    return t
end

-- Map dispatcher names to hl.dsp functions
local function get_dispatcher(command, _)
    local hypr_cmd = trim(command:match("^hypr:%s*(.+)")) or ""

    if #hypr_cmd == 0 then
        -- Handle shell commands and relative paths
        return hl.dsp.exec_cmd(path_resolve(command))
    end

    -- Parse path and args: name(args)
    local path, args_str = hypr_cmd:match("^([%w_%.]+)%s*%((.*)%)$")
    local args = {}
    if path then
        args = parse_args_table(args_str)
    else
        -- Fallback for simple "name args" syntax if no parens
        path = hypr_cmd:match("^([%w_%.]+)")
        if not path then
            return function() hl.exec_cmd("hyprctl " .. hypr_cmd) end
        end
        local rest = trim(hypr_cmd:sub(#path + 1))
        if rest ~= "" then
            args = split_comma(rest)
            if #args == 1 then
                local space_parts = {}
                for p in rest:gmatch("%S+") do table.insert(space_parts, p) end
                if #space_parts > 1 then args = space_parts end
            end
        end
    end

    local is_custom = resolve_path(M, path) ~= nil
    -- Resolve in hl.dsp (native) or M (custom)
    local func = resolve_path(hl.dsp, path) or resolve_path(M, path)

    if func then
        local call_func = function()
            -- Determine if we should pass a single table or multiple positional args
            local has_keys = false
            for k, _ in pairs(args) do if type(k) == "string" then has_keys = true; break end end

            if has_keys then
                return func(args)
            elseif #args == 0 then
                return func()
            elseif #args == 1 then
                return func(args[1])
            else
                return func(table.unpack(args))
            end
        end

        if is_custom then return call_func end
        return call_func()
    end

    -- Special case for reload
    if path == "reload" then
        return function() hl.exec_cmd("hyprctl reload") end
    end

    -- Fallback to hyprctl
    return function() hl.exec_cmd("hyprctl " .. hypr_cmd) end
end

function M.parse_and_bind(file_path)
    local file = io.open(file_path, "r")
    if not file then
        print("Error: Could not open " .. file_path)
        return
    end

    local current_flags = {}
    local current_key_lines = {}
    local command_buffer = ""

    for line in file:lines() do
        local trimmed = trim(line)
        if trimmed == "" or trimmed:sub(1, 1) == "#" then
            -- Skip empty and comments
        elseif line:sub(1, 1) == "(" then
            -- Parse flags
            local flag_str = line:match("%((.+)%)")
            current_flags = {}
            if flag_str then
                local parts = split_comma(flag_str)
                for _, p in ipairs(parts) do
                    local f = trim(p)
                    if f ~= "" then
                        current_flags[f] = true
                    end
                end
            end
        elseif line:sub(1, 1) ~= " " then
            -- Keybinding line
            current_key_lines = expand_braces(expand_ranges(line))
            command_buffer = ""
        else
            -- Command line (indented)
            if trimmed:sub(-1) == "\\" then
                command_buffer = command_buffer .. trimmed:sub(1, -2) .. " "
            else
                command_buffer = command_buffer .. trimmed
                local expanded_commands = expand_braces(expand_ranges(command_buffer))

                for i, key_line in ipairs(current_key_lines) do
                    local cmd = expanded_commands[i] or expanded_commands[1]
                    if cmd then
                        local formatted_keys = key_line:gsub("super", "SUPER"):gsub("alt", "ALT"):gsub("ctrl", "CTRL"):gsub("shift", "SHIFT")
                        formatted_keys = formatted_keys:gsub("%+", " + ")
                        formatted_keys = formatted_keys:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

                        local dispatcher = get_dispatcher(cmd, current_flags)

                        -- Only pass flags if they are not empty
                        if next(current_flags) then
                            hl.bind(formatted_keys, dispatcher, current_flags)
                        else
                            hl.bind(formatted_keys, dispatcher)
                        end
                    end
                end

                command_buffer = ""
                -- Do NOT reset flags here, they belong to the previous keybinding line or the whole block
                -- Actually, in swhkd, flags apply to the next bind.
                -- Let's reset them after use.
                current_flags = {}
                current_key_lines = {}
            end
        end
    end
    file:close()
end

M.path_resolve = path_resolve

return M
