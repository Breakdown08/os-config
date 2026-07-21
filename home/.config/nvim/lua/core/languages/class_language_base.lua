---@class LanguageBase
---@field id string
local LanguageBase = {}
LanguageBase.__index = LanguageBase

---@param id string?
---@return LanguageBase
function LanguageBase.new(id)
    local self = setmetatable({ id = id }, LanguageBase)
    events.get(Event.FILE_SAVED):connect(function(...)
        self:on_file_saved(...)
    end)
    return self
end

---@abstract
---@return table
function LanguageBase:get_formatter()
    error("Abstract method get_formatter() must be implemented")
end

---@abstract
---@param extention string
---@return table
function LanguageBase:on_file_saved(extention) end

---@abstract
---@return table
function LanguageBase:get_lsp()
    error("Abstract method get_lsp() must be implemented")
end

return LanguageBase
