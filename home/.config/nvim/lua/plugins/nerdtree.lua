local function init()
    vim.g.NERDTreeShowHidden = 1
    vim.g.NERDTreeTab = 0
    vim.g.NERDTreeTabTree = 0
end


return {
    "preservim/nerdtree",
    config = init
}
