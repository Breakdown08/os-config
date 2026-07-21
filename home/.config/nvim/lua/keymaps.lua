local nmap = function(keys, func, desc)
	vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
end

vim.g.mapleader = " "
local LEADER = "<Leader>"

-- ТУТ ОПРЕДЕЛЯЮТСЯ ГОРЯЧИЕ КЛАВИШИ
nmap("<TAB>", function()
	events.get(Event.EXPLORER_TOGGLED):emit()
end, "Проводник [вкл/выкл]")

nmap(LEADER .. "ka", ":map<CR>", "Полный список горячих клавиш")
nmap(LEADER .. "kn", ":nmap<CR>", "Cписок горячих клавиш нормального режима")
nmap(LEADER .. "kv", ":vmap<CR>", "Список горячих клавиш режима выделения")

nmap("<C-h>", "<C-w>h", "Переход на другое окно - слева")
nmap("<C-j>", "<C-w>j", "Переход на другое окно - снизу")
nmap("<C-k>", "<C-w>k", "Переход на другое окно - сверху")
nmap("<C-l>", "<C-w>l", "Переход на другое окно - справа")

nmap("<C-q>", function()
	events.get(Event.CLOSE_CURRENT_WINDOW_REQUESTED):emit()
end, "Закрыть текущее окно")

nmap(LEADER .. "[", function()
	events.get(Event.NVIM_CONFIG_ROOT_REQUESTED):emit()
end, "Открыть директорию NVIM конфигурации")

nmap(LEADER .. "]", function()
	events.get(Event.PROJECT_ROOT_REQUESTED):emit()
end, "Открыть директорию проекта")

nmap(LEADER .. "b", function()
	events.get(Event.BUILD_C_PROJECT_REQUESTED):emit()
end, "Билд C проекта")

nmap("<C-x>", ":Inspect<CR>", "Узнать группу синтаксиса под курсором")

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		local opts = { buffer = true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<space>f", vim.lsp.buf.format, opts)
	end,
})

vim.api.nvim_create_user_command("RobotType", function(opts)
	local args = opts.fargs
	local filepath = args[1]
	local wpm = tonumber(args[2]) or 120
	if not filepath then
		vim.notify(
			"Использование: :RobotType <путь_к_файлу> [скорость_wpm]",
			vim.log.levels.ERROR
		)
		return
	end
	utils.type_from_file(filepath, wpm)
end, {
	nargs = "+",
	complete = "file",
})
