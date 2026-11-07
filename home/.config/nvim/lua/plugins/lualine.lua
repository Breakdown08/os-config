vim.pack.add({
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
})

require("lualine").setup({
    options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = { "filetype" },
        lualine_z = { "encoding", "fileformat" },
    },
    inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = { "filetype" },
    },
    tabline = {
        lualine_a = { "branch" },
        lualine_c = { "tabs" },
        lualine_z = { "lsp_status" },
    },
})
