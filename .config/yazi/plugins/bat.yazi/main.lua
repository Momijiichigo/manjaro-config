local M = {}

function M:setup(opts)
    opts = opts or {}
    self.theme = opts.theme or nil
    self.theme_dark = opts.theme_dark or opts.theme or nil
    self.theme_light = opts.theme_light or opts.theme or nil
    self.style = opts.style or "plain"
    self.wrap = opts.wrap or "never"
end

local get_opts = ya.sync(function(state)
    return state.theme_dark, state.theme_light, state.style or "plain", state.wrap or "never"
end)

local function theme()
    local light = rt.term.light()
    return light == true and "light" or light == false and "dark" or "auto"
end

local function theme_hash(s)
    local h = 0
    for i = 1, #s do
        h = (h * 31 + string.byte(s, i)) % 16777216
    end
    return h
end

-- Detect available bat/batcat command and memoize version
local bat_bin, bat_version
local function get_bat_cmd()
    if bat_bin ~= nil then
        return bat_bin, bat_version
    end

    -- Try 'bat' first
    local output = Command("bat"):arg("--version"):stdout(Command.PIPED):output()
    if output and output.status.success then
        bat_bin = "bat"
        bat_version = output.stdout:match("[^\r\n]+") or "unknown"
        return bat_bin, bat_version
    end

    -- Fallback to 'batcat'
    output = Command("batcat"):arg("--version"):stdout(Command.PIPED):output()
    if output and output.status.success then
        bat_bin = "batcat"
        bat_version = output.stdout:match("[^\r\n]+") or "unknown"
        return bat_bin, bat_version
    end

    -- Default fallback if neither is found
    bat_bin = "bat"
    bat_version = "unknown"
    return bat_bin, bat_version
end

-- Key the command name, version, theme, style, and wrap settings
local function cache_key(job, active_theme, style, wrap)
    local bin, ver = get_bat_cmd()
    local id = bin .. "\0" .. ver .. "\0" .. (active_theme or "") .. "\0" .. style .. "\0" .. wrap
    return job.area.w * 16777216 + theme_hash(id)
end

function M:peek(job)
    local theme_dark, theme_light, style, wrap = get_opts()
    
    local t_mode = theme()
    local active_theme = (t_mode == "light") and theme_light or theme_dark

    local cache = ya.file_cache({ file = job.file, skip = cache_key(job, active_theme, style, wrap) })
    if cache and self:preload(job) == 1 then
        local f = io.open(tostring(cache), "r")
        if f then
            local data = f:read("*a")
            f:close()
            if data:sub(-1) == "\n" then
                data = data:sub(1, -2)
            end
            local lines = {}
            for line in (data .. "\n"):gmatch("([^\n]*)\n") do
                lines[#lines + 1] = line
            end
            local start = math.max(1, (job.skip or 0) + 1)
            if start > #lines then
                ya.emit("peek", { math.max(0, #lines - job.area.h), only_if = job.file.url, upper_bound = true })
                return
            end
            local stop = math.min(#lines, start + job.area.h - 1)
            local slice = table.concat(lines, "\n", start, stop)
            return ya.preview_widget(job, ui.Text.parse(slice):area(job.area))
        end
    end
end

function M:seek(job)
    local h = cx.active.current.hovered
    if not h or h.url ~= job.file.url then
        return
    end
    local step = math.floor(job.units * job.area.h / 10)
    ya.emit("peek", {
        math.max(0, cx.active.preview.skip + step),
        only_if = job.file.url,
    })
end

function M:preload(job)
    local theme_dark, theme_light, style, wrap = get_opts()
    
    local t_mode = theme()
    local active_theme = (t_mode == "light") and theme_light or theme_dark

    local cache = ya.file_cache({ file = job.file, skip = cache_key(job, active_theme, style, wrap) })
    if not cache then
        return 1
    end
    local cha = fs.cha(cache)
    if cha and cha.len > 0 then
        return 1
    end

    local bin = get_bat_cmd()

    local cmd = Command(bin)
        :arg("--style=" .. style)
        :arg("--color=always")
        :arg("--wrap=" .. wrap)
        :arg("--terminal-width")
        :arg(tostring(job.area.w))

    if active_theme then
        cmd:arg("--theme"):arg(tostring(active_theme))
    end

    local output, err = cmd
        :arg(tostring(job.file.url.path))
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :output()

    if not output then
        local detail = err and (" (" .. tostring(err) .. ")") or ""
        ya.preview_widget(
            job,
            ui.Text("'bat' or 'batcat' command not found on PATH" .. detail):area(job.area)
        )
        return 2
    end
    if not output.status.success then
        local first = output.stderr:match("([^\n]+)") or "no stderr"
        ya.preview_widget(
            job,
            ui.Text(bin .. " failed (exit " .. tostring(output.status.code) .. "): " .. first):area(job.area)
        )
        return 2
    end

    fs.write(cache, output.stdout)
    return 1
end

return M
