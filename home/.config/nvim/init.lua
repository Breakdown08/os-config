project_root = vim.fn.getcwd()
config_root = vim.fn.stdpath("config")

-- Раздел объявлений
require("settings")
require("core.print") -- обертка для вывода в консоль
require("core.event_bus") -- шина событий
require("core.enum_language") -- поддерживаемые языки разработки
require("core.enum_connection_status") -- абстрактный статус подключения, например к LSP/DAP
require("core.utils") -- вспомогательные утилиты
require("core.lazy") -- менеджер плагинов
require("keymaps") -- раскладка горячих клавиш
require("controllers.explorer") -- контроллер по работе с проводником

-- Раздел вызовов
events.get(Event.PROJECT_TYPE_REQUESTED):emit()
