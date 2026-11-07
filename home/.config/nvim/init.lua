-- Before plugins load, so their <Leader> mappings use it
vim.g.mapleader = " "

require("settings")
require("keymaps")
require("commands")
require("languages")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { import = "plugins" },
    rocks = { enabled = false },
})
