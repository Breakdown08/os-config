vim.api.nvim_create_user_command("CBuild", function()
    local file = vim.api.nvim_buf_get_name(0)
    if not file:match("%.c$") then
        vim.notify("Not a C file", vim.log.levels.ERROR)
        return
    end
    for _, output in ipairs({ { "-S" }, { "-o", "main" } }) do
        local cmd = vim.list_extend({ "clang", file }, output)
        local result = vim.system(vim.list_extend(cmd, { "-Wall", "-Wextra", "-std=c11", "-lX11" })):wait()
        if result.code ~= 0 then
            vim.notify("clang:\n" .. result.stderr, vim.log.levels.ERROR)
            return
        end
    end
    vim.notify("Built ./main")
end, { desc = "Compile the current C file to ./main and its assembly" })

-- Types a file into the current buffer character by character, for screencasts.
vim.api.nvim_create_user_command("RobotType", function(opts)
    local path, wpm = opts.fargs[1], tonumber(opts.fargs[2]) or 120
    local file = io.open(path, "r")
    if not file then
        vim.notify("Cannot open " .. path, vim.log.levels.ERROR)
        return
    end
    local chars = vim.fn.split(file:read("*a"), "\\zs")
    file:close()

    local delay = math.max(10, math.floor(60000 / (wpm * 6)))
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    local index = 1
    local function type_next()
        local char = chars[index]
        if not char then
            return
        end
        if char == "\n" then
            vim.api.nvim_put({ "" }, "l", true, true)
        else
            vim.api.nvim_put({ char }, "c", true, true)
        end
        index = index + 1
        vim.defer_fn(type_next, delay)
    end
    type_next()
end, { nargs = "+", complete = "file", desc = "RobotType <file> [wpm]" })
