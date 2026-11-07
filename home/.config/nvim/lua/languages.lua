-- Servers are described in lsp/<name>.lua. Nvim maps grn, grr, gri, grt, gra, gO, K and
-- insert-mode Ctrl+S on its own.
vim.lsp.enable({ "lua_ls", "ty" })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.lua",
    desc = "Format Lua with stylua",
    callback = function(args)
        local input = table.concat(vim.api.nvim_buf_get_lines(args.buf, 0, -1, false), "\n") .. "\n"
        local result = vim.system({ "stylua", "--indent-type", "Spaces", "--indent-width", "4", "-" }, { stdin = input })
            :wait()
        if result.code ~= 0 then
            vim.notify("stylua: " .. result.stderr, vim.log.levels.WARN)
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
