vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"

vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- Built-in autocompletion: LSP first, then words from open buffers
vim.opt.autocomplete = true
vim.opt.complete = "o,.,w,b"
vim.opt.completeopt = "menuone,noselect,popup,fuzzy"
vim.opt.pumborder = "rounded"
vim.opt.winborder = "rounded"
