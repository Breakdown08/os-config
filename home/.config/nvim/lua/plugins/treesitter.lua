local function apply_syntax_colors()
    vim.api.nvim_set_hl(0, "@include", { fg = "#145c66", bold = true }) -- импорты (import, require)

    local field_color = "#976e61" -- поля, свойства, переменные, параметры функций
    vim.api.nvim_set_hl(0, "@field", { fg = field_color })
    vim.api.nvim_set_hl(0, "@property", { fg = field_color })
    vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = field_color })
    vim.api.nvim_set_hl(0, "@variable", { fg = field_color })
    vim.api.nvim_set_hl(0, "@parameter", { fg = field_color })
    vim.api.nvim_set_hl(0, "@table", { fg = field_color })
    vim.api.nvim_set_hl(0, "@identifier", { fg = field_color })

    local function_color = "#3e599a" -- ключевые слова объявления функций и методов
    vim.api.nvim_set_hl(0, "@keyword.function", { fg = function_color })
    vim.api.nvim_set_hl(0, "@keyword.method", { fg = function_color })

    vim.api.nvim_set_hl(0, "@function.method", { fg = "#662a73" }) -- именования функций после ключевых слов

    local function_call_color = "#328c77" -- вызовы функций и методов
    vim.api.nvim_set_hl(0, "@function.method.call", { fg = function_call_color })
    vim.api.nvim_set_hl(0, "@function.call", { fg = function_call_color })
    vim.api.nvim_set_hl(0, "@lsp.type.function", { fg = function_call_color })
    vim.api.nvim_set_hl(0, "@lsp.type.method", { fg = function_call_color })

    local builtin_color = "#be2e57" -- -- зарезервированные слова
    vim.api.nvim_set_hl(0, "@module.builtin", { fg = builtin_color })
    vim.api.nvim_set_hl(0, "@function.builtin", { fg = builtin_color })
    vim.api.nvim_set_hl(0, "@variable.builtin", { fg = builtin_color })

    vim.api.nvim_set_hl(0, "@string", { fg = "#c08537" })
    vim.api.nvim_set_hl(0, "@string.escape", { fg = "#ac8b67" }) -- экранирование в строках
    vim.api.nvim_set_hl(0, "@number", { fg = "#d2e26a" })
    vim.api.nvim_set_hl(0, "@constructor", { fg = "#d2e26a" })

    local type_color = "#ea5daa"
    vim.api.nvim_set_hl(0, "@type", { fg = type_color })
    vim.api.nvim_set_hl(0, "@type.builtin", { fg = type_color })

    local keyword_color = "#ff8983"
    vim.api.nvim_set_hl(0, "@constant", { fg = keyword_color })
    vim.api.nvim_set_hl(0, "@keyword", { fg = keyword_color, bold = true }) -- ключевые слова (if, return, func)

    local action_color = "#00accd"
    vim.api.nvim_set_hl(0, "@keyword.conditional", { fg = action_color, bold = true }) -- условия (if, else, switch)
    vim.api.nvim_set_hl(0, "@keyword.repeat", { fg = action_color, bold = true }) -- циклы (for, while)
    vim.api.nvim_set_hl(0, "@exception", { fg = action_color }) -- исключения (try, catch)

    vim.api.nvim_set_hl(0, "@operator", { fg = "#9bb0a5" }) -- операторы (+, -, =, *)

    local symbol_color = "#ffea97"
    vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = symbol_color }) -- скобки (), [], {}
    vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = symbol_color }) -- разделители . , ; :

    vim.api.nvim_set_hl(0, "@comment", { fg = "#b8a99a", italic = false })
end

local parsers = {
    "bash",
    "c",
    "csv",
    "dockerfile",
    "gdscript",
    "git_config",
    "gitignore",
    "godot_resource",
    "json",
    "kdl",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "python",
    "query",
    "requirements",
    "ssh_config",
    "toml",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
}

-- Treesitter indentation is experimental and breaks GDScript.
local no_indent = { gdscript = true }

local function map_textobjects()
    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    for keys, capture in pairs({
        aa = "@parameter.outer",
        ia = "@parameter.inner",
        af = "@function.outer",
        ["if"] = "@function.inner",
        ac = "@class.outer",
        ic = "@class.inner",
    }) do
        vim.keymap.set({ "x", "o" }, keys, function()
            select.select_textobject(capture, "textobjects")
        end)
    end

    for keys, motion in pairs({
        ["]m"] = { move.goto_next_start, "@function.outer" },
        ["]]"] = { move.goto_next_start, "@class.outer" },
        ["]M"] = { move.goto_next_end, "@function.outer" },
        ["]["] = { move.goto_next_end, "@class.outer" },
        ["[m"] = { move.goto_previous_start, "@function.outer" },
        ["[["] = { move.goto_previous_start, "@class.outer" },
        ["[M"] = { move.goto_previous_end, "@function.outer" },
        ["[]"] = { move.goto_previous_end, "@class.outer" },
    }) do
        vim.keymap.set({ "n", "x", "o" }, keys, function()
            motion[1](motion[2], "textobjects")
        end)
    end

    vim.keymap.set("n", "<leader>a", function()
        swap.swap_next("@parameter.inner")
    end)
    vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous("@parameter.inner")
    end)
end

local function init()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
            if not pcall(vim.treesitter.start, args.buf) then
                return
            end
            local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
            if not no_indent[lang] and vim.treesitter.query.get(lang, "indents") then
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    })

    require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
    })
    map_textobjects()
    apply_syntax_colors()
end

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    lazy = false,
    build = ":TSUpdate",
    config = init,
}
