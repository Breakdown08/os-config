-- Before plugins load, so their <Leader> mappings use it
vim.g.mapleader = " "

require("settings")
require("keymaps")
require("commands")
require("languages")

-- Treesitter goes first: its PackChanged hook has to exist before the first vim.pack.add
require("plugins.treesitter")
require("plugins.lualine")
require("plugins.colorizer")
require("plugins.oil")
require("plugins.fzf")
