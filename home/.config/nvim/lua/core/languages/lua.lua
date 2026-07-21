local LanguageBase = require("core.languages.class_language_base")
---@class LuaLanguage : LanguageBase
local LuaLanguage = {}
LuaLanguage.__index = LuaLanguage

setmetatable(LuaLanguage, {
    __index = LanguageBase,
})

---@param id string
---@return LuaLanguage
function LuaLanguage.new(id)
    id = id or "lua_ls"
    local self = LanguageBase.new(id)
    setmetatable(self, LuaLanguage)
    return self
end

---@return table
function LuaLanguage:get_formatter()
    return {
        command = "stylua",
        args = { "-", "--indent-type", "spaces", "--indent-width", "4" },
        stdin = true,
    }
end

function LuaLanguage:on_file_saved(extension)
    if extension ~= "lua" then
        return
    end
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local formatter = self:get_formatter()
    local cmd = string.format("%s %s", formatter.command, table.concat(formatter.args or {}, " "))
    vim.cmd("silent! %!" .. cmd)
    vim.api.nvim_win_set_cursor(0, cursor_pos)
end

---@return table
function LuaLanguage:get_lsp()
    return {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_dir = function(fname)
            return vim.fs.root(fname, { ".luarc.json", ".git" })
        end,
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    }
end

return LuaLanguage
