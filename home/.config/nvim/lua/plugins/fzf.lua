vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

for keys, picker in pairs({
    ["<Leader>f"] = { "files", "Find a file" },
    ["<Leader>g"] = { "live_grep", "Search the project" },
    ["<Leader><Leader>"] = { "buffers", "Switch buffer" },
    ["<Leader>d"] = { "diagnostics_document", "Diagnostics in the file" },
    ["<Leader>h"] = { "helptags", "Search help" },
    ["<Leader>k"] = { "keymaps", "Search mappings" },
    ["<Leader>r"] = { "resume", "Resume the last search" },
}) do
    vim.keymap.set("n", keys, "<Cmd>FzfLua " .. picker[1] .. "<CR>", { desc = picker[2] })
end
