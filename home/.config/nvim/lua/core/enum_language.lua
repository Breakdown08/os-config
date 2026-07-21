---@class Language
---@field LUA string
---@field PYTHON string
Language = {
	LUA = "lua",
	PYTHON = "python",
}

---@type table<string, LanguageBase>
allowed_languages = {
	[Language.LUA] = require("core.languages.lua").new(),
	[Language.PYTHON] = require("core.languages.python").new(),
}
