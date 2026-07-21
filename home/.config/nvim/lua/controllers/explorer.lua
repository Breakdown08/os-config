local function _on_nvim_config_root_requested(data)
	vim.cmd("NERDTree " .. vim.fn.stdpath("config"))
end

local function _on_project_root_requested(data)
	vim.cmd("NERDTree " .. project_root)
end

local function _on_close_current_window_requested(data)
	local wins = vim.api.nvim_list_wins()
	if #wins > 1 then
		local current_win = vim.api.nvim_get_current_win()
		local bufnr = vim.api.nvim_win_get_buf(current_win)
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		local filename = vim.fn.fnamemodify(bufname, ":t")
		vim.cmd("close")
		print(string.format("Closed window '%s'", filename))
	end
end

local function is_nerdtree_open()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "nerdtree" then
			return true
		end
	end
	return false
end

local function _on_explorer_toggled(data)
	local wins = vim.api.nvim_list_wins()
	if #wins > 1 or is_nerdtree_open() == false then
		vim.cmd("NERDTreeToggle")
	end
end

local function _on_build_c_project_requested()
	local file = vim.api.nvim_buf_get_name(0)
	if not file:match("%.c$") then
		vim.notify("Ошибка: не C-файл", "error")
		return
	end
	local output = file:gsub("%.c$", "")
	local common_args = { "-Wall", "-Wextra", "-std=c11", "-lX11" }
	local custom_args = {}
	local create = function(output_mode)
		local args = {}
		if output_mode == "-o" then
			args = utils.merge_tables({ "clang", file, output_mode }, { "main" }, common_args, custom_args)
		else
			args = utils.merge_tables({ "clang", file, output_mode }, common_args, custom_args)
		end
		print(args)
		return args
	end
	local result_1 = vim.system(create("-S")):wait()
	local result_2 = vim.system(create("-o")):wait()

	if result_1.code ~= 0 then
		vim.notify(("Ошибка Clang:\n%s"):format(result_1.stderr), "error")
		return
	end
	if result_2.code ~= 0 then
		vim.notify(("Ошибка Clang:\n%s"):format(result_2.stderr), "error")
		return
	end
	vim.notify(("Собрано через Clang: ./%s"):format(output), "info", { title = "C Build" })
end

events.get(Event.EXPLORER_TOGGLED):connect(_on_explorer_toggled)
events.get(Event.NVIM_CONFIG_ROOT_REQUESTED):connect(_on_nvim_config_root_requested)
events.get(Event.PROJECT_ROOT_REQUESTED):connect(_on_project_root_requested)
events.get(Event.CLOSE_CURRENT_WINDOW_REQUESTED):connect(_on_close_current_window_requested)
events.get(Event.BUILD_C_PROJECT_REQUESTED):connect(_on_build_c_project_requested)
