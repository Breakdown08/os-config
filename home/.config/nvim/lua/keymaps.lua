local function map(keys, action, desc)
    vim.keymap.set("n", keys, action, { desc = desc })
end

local project_root = vim.fn.getcwd()

map("<Tab>", function()
    if vim.bo.filetype == "oil" then
        require("oil").close()
    else
        require("oil").open()
    end
end, "Toggle the file explorer")
map("<Leader>[", function()
    require("oil").open(vim.fn.stdpath("config"))
end, "Open the Neovim config")
map("<Leader>]", function()
    require("oil").open(project_root)
end, "Open the project root")

map("<C-h>", "<C-w>h", "Go to the window on the left")
map("<C-j>", "<C-w>j", "Go to the window below")
map("<C-k>", "<C-w>k", "Go to the window above")
map("<C-l>", "<C-w>l", "Go to the window on the right")
map("<C-q>", function()
    if #vim.api.nvim_list_wins() > 1 then
        vim.cmd.close()
    end
end, "Close the window")

map("<Leader>b", "<Cmd>CBuild<CR>", "Build the C file")
map("<C-x>", "<Cmd>Inspect<CR>", "Show highlight groups under the cursor")

-- Completion menu: Tab and Shift+Tab walk it or jump through a snippet, Enter accepts the selection
vim.keymap.set("i", "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    elseif vim.snippet.active({ direction = 1 }) then
        return "<Cmd>lua vim.snippet.jump(1)<CR>"
    end
    return "<Tab>"
end, { expr = true })
vim.keymap.set("i", "<S-Tab>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-p>"
    elseif vim.snippet.active({ direction = -1 }) then
        return "<Cmd>lua vim.snippet.jump(-1)<CR>"
    end
    return "<S-Tab>"
end, { expr = true })
vim.keymap.set("i", "<CR>", function()
    return vim.fn.complete_info({ "selected" }).selected ~= -1 and "<C-y>" or "<CR>"
end, { expr = true })
