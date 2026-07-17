local LanguageBase = require("core.languages.class_language_base")

---@class LuaLanguage : LanguageBase
---@field name string
---@field autoformat_config table
---@field lsp_config table
local LuaLanguage = {}
LuaLanguage.__index = LuaLanguage

---Наследование от LanguageBase
setmetatable(LuaLanguage, { __index = LanguageBase })

---@param name string?
---@return LuaLanguage
function LuaLanguage.new(name)
    local self = setmetatable({}, LuaLanguage)
    self.name = name or "lua_ls"
    self.autoformat_config = {
        formatter = "stylua",
        config_file = ".styluaignore"
    }
    self.lsp_config = {
        server = "lua_ls",
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { enable = true },
                workspace = { checkThirdParty = false }
            }
        }
    }
    return self
end

---@return string
function LuaLanguage:create_start_template_project()
    local template = [[
-- Project entry point
print("Hello from ]] .. self.name .. [[")

-- Add your code here
]]
    return template
end

return LuaLanguage