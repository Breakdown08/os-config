-- Directories open as editable buffers: rename, move and delete files with normal edits, then :w
return {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
        view_options = { show_hidden = true },
        -- Keep Ctrl+H and Ctrl+L for moving between windows
        keymaps = { ["<C-h>"] = false, ["<C-l>"] = false },
    },
}
