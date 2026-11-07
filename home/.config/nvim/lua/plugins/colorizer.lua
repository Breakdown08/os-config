vim.pack.add({ "https://github.com/catgoose/nvim-colorizer.lua" })

-- Paint color codes and CSS color functions with their own color
require("colorizer").setup({
    filetypes = { "*" },
    options = { parsers = { css = true, sass = { enable = true } } },
})
