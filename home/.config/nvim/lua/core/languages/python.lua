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
    self.name = name or "ty"
    
    -- Настройка автоформатирования через Ruff
    self.autoformat_config = {
        formatter = "ruff",
        config_file = nil  -- ruff читает настройки из pyproject.toml
    }
    
    -- Настройка LSP с Ty (от Astral) для линтинга и типов
    self.lsp_config = {
            server = "ty",
            cmd = { "ty", "server" },  -- правильная команда для LSP сервера
        }
    
    -- Ruff для форматирования на сохранение (используем напрямую, быстро)
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
            local file_path = vim.fn.expand("%:p")
            -- Форматируем через ruff (быстро и асинхронно)
            vim.fn.jobstart({ "uvx", "ruff", "format", file_path }, {
                on_exit = function()
                    -- Перезагружаем файл после форматирования
                    vim.cmd("edit!")
                end,
            })
        end,
    })
    
    -- Ruff для линтинга и автоисправления (опционально)
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.py",
        callback = function()
            local file_path = vim.fn.expand("%:p")
            -- Запускаем ruff check с автоисправлением
            vim.fn.jobstart({ "uvx", "ruff", "check", "--fix", file_path }, {
                on_exit = function()
                    -- Обновляем буфер после исправлений
                    vim.cmd("checktime")
                end,
            })
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

if __name__ == "__main__":
    main()
]]
    return template
end

return PythonLanguage
