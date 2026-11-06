utils = {}

utils.recognize_project = function()
	local cwd = vim.fn.getcwd()
	if vim.fn.filereadable(cwd .. "/init.lua") == 1 then
		return Language.LUA
	elseif vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 or vim.fn.filereadable(cwd .. "/Makefile") == 1 then
		return Language.C
	else
		return "unknown"
	end
end

utils.merge_tables = function(...)
	local res = {}
	for _, t in ipairs({ ... }) do
		for _, v in ipairs(t) do
			table.insert(res, v)
		end
	end
	return res
end

utils.type_from_file = function(source_path, wpm)
	local file = io.open(source_path, "r")
	if not file then
		vim.notify("Не удалось открыть файл: " .. source_path, vim.log.levels.ERROR)
		return
	end
	local content = file:read("*all")
	file:close()
	if not content or content == "" then
		vim.notify("Файл пуст", vim.log.levels.WARN)
		return
	end
	vim.o.encoding = "utf-8"
	local words_per_min = wpm or 240
	local delay_ms = math.floor(60000 / (words_per_min * 6))
	if delay_ms < 10 then
		delay_ms = 10
	end
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
	vim.api.nvim_win_set_cursor(0, { 1, 0 })
	local index = 1
	local chars = vim.fn.split(content, "\\zs")
	local len = #chars
	local function type_next_char()
		if index > len then
			return
		end
		local char = chars[index]
		if char == "\n" then
			vim.api.nvim_put({ "" }, "l", true, true)
		else
			vim.api.nvim_put({ char }, "c", true, true)
		end
		index = index + 1
		vim.defer_fn(type_next_char, delay_ms)
	end
	type_next_char()
end
