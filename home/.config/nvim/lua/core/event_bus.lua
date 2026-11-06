---@module 'EventClass'
local EventClass = require("core.class_event")

require("events")

--- @class EventBus
--- @field get fun(event_name: string): EventClass
local EventBus = {}

---@type table<string, EventClass>
local storage = {}

for key, _ in pairs(Event) do
	storage[key] = EventClass.new(key)
end

---@param event_name Event
---@return EventClass
function EventBus.get(event_name)
	local event = storage[event_name]
	if not event then
		error(string.format("Событие '%s' не зарегистрировано в EventBus", event_name))
	end
	return event
end

---@type EventBus
events = EventBus

return EventBus

