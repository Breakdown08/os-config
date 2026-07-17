---@class LanguageBase
---@field name string
---@field autoformat_config table
---@field lsp_config table
local LanguageBase = {}
LanguageBase.__index = LanguageBase

---@param name string?
---@return LanguageBase
function LanguageBase.new(name)
    local self = setmetatable({}, LanguageBase)
    self.name = name or "base_language"
    self.autoformat_config = {}
    self.lsp_config = {}
    return self
end

---@return table
function LanguageBase:get_autoformat_config()
    return self.autoformat_config
end

---@return table
function LanguageBase:get_lsp_config()
    return self.lsp_config
end

---@return string
function LanguageBase:create_start_template_project()
    return ""
end

return LanguageBase