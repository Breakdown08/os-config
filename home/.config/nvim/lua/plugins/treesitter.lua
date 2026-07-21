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

local function init()
	require("nvim-treesitter.configs").setup({
		-- Add languages to be installed here that you want installed for treesitter
		ensure_installed = { "c", "lua", "query" },
		-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
		auto_install = true,
		-- Install languages synchronously (only applied to `ensure_installed`)
		sync_install = false,
		-- List of parsers to ignore installing
		ignore_install = {},
		-- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
		modules = {},
		highlight = { enable = true },
		indent = { enable = true, disable = { "gdscript" } },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<c-space>",
				node_incremental = "<c-space>",
				scope_incremental = "<c-s>",
				node_decremental = "<M-space>",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>A"] = "@parameter.inner",
				},
			},
		},
	})
	apply_syntax_colors()
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	lazy = false,
	build = ":TSUpdate",
	config = init,
}
