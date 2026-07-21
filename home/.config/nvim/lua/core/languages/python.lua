local LanguageBase = require("core.languages.class_language_base")

---@class PythonLanguage : LanguageBase
local PythonLanguage = {}
PythonLanguage.__index = PythonLanguage

setmetatable(PythonLanguage, {
    __index = LanguageBase,
})

---@param id string
---@return PythonLanguage
function PythonLanguage.new(id)
    id = id or "ty"
    local self = LanguageBase.new(id)
    setmetatable(self, PythonLanguage)
    return self
end

---@return table
function PythonLanguage:get_formatter()
    return {
        command = "ruff",
        args = { "format", "-" },
        stdin = true,
    }
end

function PythonLanguage:on_file_saved(extension)
    if extension ~= "py" then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    local formatter = self:get_formatter()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local content = table.concat(lines, "\n")

    local cmd = table.concat({ formatter.command, unpack(formatter.args) }, " ")
    local result = vim.fn.system(cmd, content)

    if vim.v.shell_error == 0 then
        local formatted_lines = vim.split(result, "\n")
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted_lines)
        vim.api.nvim_win_set_cursor(0, cursor_pos)
    end
end
---@return table
function PythonLanguage:get_lsp()
    return {
        cmd = { "ty", "server" },
        filetypes = { "python" },
        root_dir = function(fname)
            return vim.fs.root(fname, { "pyproject.toml", "setup.py", "requirements.txt", ".git" })
        end,
    }
end

return PythonLanguage
