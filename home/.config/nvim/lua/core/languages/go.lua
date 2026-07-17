local LanguageBase = require("core.languages.class_language_base")

---@class GoLanguage : LanguageBase
---@field name string
---@field autoformat_config table
---@field lsp_config table
local GoLanguage = {}
GoLanguage.__index = GoLanguage

---Наследование от LanguageBase
setmetatable(GoLanguage, { __index = LanguageBase })

---@param name string?
---@return GoLanguage
function GoLanguage.new(name)
    local self = setmetatable({}, GoLanguage)
    self.name = name or "gopls"
    self.autoformat_config = {
        formatter = "gofumpt",
        config_file = nil
    }
    self.lsp_config = {
        server = "gopls",
        settings = {
            gopls = {
                analyses = { unusedparams = true },
                staticcheck = true,
            }
        }
    }    
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*." .. "go",
        callback = function()
            vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
        end,
    })
    return self
end

---@return string
function GoLanguage:create_start_template_project()
    local template = [[package main

import "fmt"

func main() {
	fmt.Println("Hello from ]] .. self.name .. [[")
	// Add your code here
}
]]
    return template
end

return GoLanguage