---@class EventClass
---@field name string
---@field listeners fun(...):[]
local EventClass = {}
EventClass.__index = EventClass


---@param name string?
---@return EventClass
function EventClass.new(name)
    local self = setmetatable({}, EventClass)
    self.name = name or "unnamed_event"
    self.listeners = {}
    return self
end


---@param callback fun(...):[]
function EventClass:connect(callback)
    table.insert(self.listeners, callback)
end


---@param ... any
function EventClass:emit(...)
    for _, callback in ipairs(self.listeners) do
        local success, err = pcall(callback, ...)
        if not success then
            print(string.format("Ошибка в слушателе '%s': %s", self.name, err))
        end
    end
end


return EventClass