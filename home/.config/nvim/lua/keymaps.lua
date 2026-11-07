local function map(keys, action, desc)
    vim.keymap.set("n", keys, action, { desc = desc })
end

local project_root = vim.fn.getcwd()

map("<Tab>", function()
    -- Keep the tree when it is the only window left
    if #vim.api.nvim_list_wins() > 1 or vim.bo.filetype ~= "nerdtree" then
        vim.cmd("NERDTreeToggle")
    end
end, "Toggle the file explorer")
map("<Leader>[", function()
    vim.cmd("NERDTree " .. vim.fn.stdpath("config"))
end, "Open the Neovim config")
map("<Leader>]", function()
    vim.cmd("NERDTree " .. project_root)
end, "Open the project root")

map("<Leader>ka", "<Cmd>map<CR>", "List all mappings")
map("<Leader>kn", "<Cmd>nmap<CR>", "List normal mode mappings")
map("<Leader>kv", "<Cmd>vmap<CR>", "List visual mode mappings")

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
