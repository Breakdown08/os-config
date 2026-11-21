-- Servers are described in lsp/<name>.lua. Nvim maps grn, grr, gri, grt, gra, gO, K and
-- insert-mode Ctrl+S on its own.
vim.lsp.enable({ "lua_ls", "ty" })

-- Without the Godot editor connecting would only warn: probe the port first
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gdscript",
    desc = "Attach the Godot language server if the editor is running",
    callback = function(args)
        local config = vim.lsp.config.gdscript
        local tcp = vim.uv.new_tcp()
        tcp:connect("127.0.0.1", config.port, function(err)
            tcp:close()
            if err then
                return
            end
            vim.schedule(function()
                local root = vim.fs.root(args.buf, config.root_markers)
                vim.lsp.start(vim.tbl_extend("force", config, { root_dir = root }), { bufnr = args.buf })
            end)
        end)
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        -- Accepting an item applies its snippet, auto-imports and other edits
        vim.lsp.completion.enable(true, args.data.client_id, args.buf)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
    end,
})

-- Formatters read the buffer from stdin and print the result
local formatters = {
    lua = { "stylua", "--indent-type", "Spaces", "--indent-width", "4", "-" },
    gdscript = { "gdscript-formatter", "--stdout" },
}

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Format the buffer on save",
    callback = function(args)
        local cmd = formatters[vim.bo[args.buf].filetype]
        if not cmd then
            return
        end
        local input = table.concat(vim.api.nvim_buf_get_lines(args.buf, 0, -1, false), "\n") .. "\n"
        local result = vim.system(cmd, { stdin = input }):wait()
        if result.code ~= 0 then
            vim.notify(cmd[1] .. ": " .. result.stderr, vim.log.levels.WARN)
            return
        end
        if result.stdout == input then
            return
        end
        local view = vim.fn.winsaveview()
        vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, vim.split(result.stdout:gsub("\n$", ""), "\n"))
        vim.fn.winrestview(view)
    end,
})
