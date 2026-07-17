local LanguageBase = require("core.languages.class_language_base")

---@class PythonLanguage : LanguageBase
---@field name string
---@field autoformat_config table
---@field lsp_config table
local PythonLanguage = {}
PythonLanguage.__index = PythonLanguage

---Наследование от LanguageBase
setmetatable(PythonLanguage, { __index = LanguageBase })

---@param name string?
---@return PythonLanguage
function PythonLanguage.new(name)
    local self = setmetatable({}, PythonLanguage)
    self.name = name or "pyright"
    self.autoformat_config = {
        formatter = "black",
        config_file = nil
    }
    self.lsp_config = {
        server = "pyright",
        settings = {
            pyright = {
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
            }
        }
    }    
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
            vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
        end,
    })
    return self
end

---@return string
function PythonLanguage:create_start_template_project()
    local template = [[#!/usr/bin/env python3
# -*- coding: utf-8 -*-

def main():
    print("Hello from ]] .. self.name .. [[")
    # Add your code here

if __name__ == "__main__":
    main()
]]
    return template
end

return PythonLanguage
