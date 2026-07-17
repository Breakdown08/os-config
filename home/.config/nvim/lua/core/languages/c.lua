local LanguageBase = require("core.languages.class_language_base")

---@class CLanguage : LanguageBase
---@field name string
---@field autoformat_config table
---@field lsp_config table
local CLanguage = {}
CLanguage.__index = CLanguage

---Наследование от LanguageBase
setmetatable(CLanguage, { __index = LanguageBase })

---@param name string?
---@return CLanguage
function CLanguage.new(name)
    local self = setmetatable({}, CLanguage)
    self.name = name or "clangd"
    self.autoformat_config = {}
    self.lsp_config = {
        capabilities = capabilities,
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        single_file_support = true,
        root_dir = project_root
    }
    return self
end

---@return string
function CLanguage:create_start_template_project()
    local template = [[
-- Project entry point
print("Hello from ]] .. self.name .. [[")

-- Add your code here
]]
    return template
end

return CLanguage