return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
        { "<Leader>f", "<Cmd>FzfLua files<CR>", desc = "Find a file" },
        { "<Leader>g", "<Cmd>FzfLua live_grep<CR>", desc = "Search the project" },
        { "<Leader><Leader>", "<Cmd>FzfLua buffers<CR>", desc = "Switch buffer" },
        { "<Leader>d", "<Cmd>FzfLua diagnostics_document<CR>", desc = "Diagnostics in the file" },
        { "<Leader>h", "<Cmd>FzfLua helptags<CR>", desc = "Search help" },
        { "<Leader>k", "<Cmd>FzfLua keymaps<CR>", desc = "Search mappings" },
        { "<Leader>r", "<Cmd>FzfLua resume<CR>", desc = "Resume the last search" },
    },
    opts = {},
}
