---@param ... any
---@return string
local function format_args(...)
	local args = { ... }
	local result = {}
	for i, v in ipairs(args) do
		table.insert(result, vim.inspect(v))
	end
	return table.concat(result, " ")
end

---@param ... any
_G.print = function(...)
	vim.notify(format_args(...), vim.log.levels.INFO)
end

---@param ... any
_G.printw = function(...)
	vim.notify(format_args(...), vim.log.levels.WARN)
end

---@param ... any
_G.printe = function(...)
	vim.notify(format_args(...), vim.log.levels.ERROR)
end

