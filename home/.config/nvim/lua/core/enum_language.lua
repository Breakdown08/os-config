---@class Language
---@field C string
---@field LUA string
---@field GO string
---@field PYTHON string
Language = {
    C = "c",
    LUA = "lua",
    GO = "go",
    PYTHON = "python"
}

---@type table<string, LanguageBase>
allowed_languages = {
    [Language.C] = require("core.languages.c").new(),
    [Language.LUA] = require("core.languages.lua").new(),
    [Language.GO] = require("core.languages.go").new(),
    [Language.PYTHON] = require("core.languages.python").new(),
}
