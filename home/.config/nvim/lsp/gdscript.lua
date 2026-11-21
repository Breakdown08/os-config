-- Godot serves the language server itself while the editor has the project open;
-- languages.lua starts it only when the port answers.
local port = tonumber(vim.env.GDScript_Port) or 6005

return {
    cmd = vim.lsp.rpc.connect("127.0.0.1", port),
    port = port,
    filetypes = { "gdscript" },
    root_markers = { "project.godot", ".git" },
}
