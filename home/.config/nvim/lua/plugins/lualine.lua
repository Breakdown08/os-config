local colors = {
    active = {
        fg = '#000000',
        bg = '#6ABC3D'
    },
    inactive = {
        fg = '#000000',
        bg = '#D94646'
    },
    accent = {
        fg = '#000000',
        bg = '#D9BC46'
    }
}

local _dap_status = ConnectionStatus.DISABLED
local _lsp_status = ConnectionStatus.DISABLED


local function get_color_by_connection_status(status)
    if status == ConnectionStatus.DISABLED then
        return colors.inactive
    elseif status == ConnectionStatus.ENABLED then
        return colors.active
    elseif status == ConnectionStatus.ACTIVE then
        return colors.accent
    else
        return colors.inactive
    end
end



local function _on_dap_status_changed(new_status)
    _dap_status = new_status
    require('lualine').refresh()
end


local function _on_lsp_status_changed(new_status)
    _lsp_status = new_status
    require('lualine').refresh()
end


local function init()
    events.get(Event.DAP_STATUS_CHANGED):connect(_on_dap_status_changed)
    events.get(Event.LSP_STATUS_CHANGED):connect(_on_lsp_status_changed)
    require('lualine').setup({
        options = {
            theme = 'auto',
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' },
            globalstatus = true,
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'diff', 'diagnostics' },
            lualine_c = {
                {
                    'filename',
                    cond = function()
                        local full_path = vim.fn.expand('%:p')
                        return not string.find(full_path or '', 'NERD_tree_')
                    end
                }
            },
            lualine_x = { 'location' },
            lualine_y = { 'filetype' },
            lualine_z = { 'encoding', 'fileformat' }
        },
        inactive_sections = {
            lualine_a = { 'filename' },
            lualine_b = { 'filetype' },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {
            lualine_a = {'branch'},
            lualine_b = {
                function()
                    return 'Project: ' .. Project.type
                end
            },
            lualine_c = { 'tabs' },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {
                {
                    function() return 'LSP' end,
                    color = function() return get_color_by_connection_status(_lsp_status) end
                },
                {
                    function() return 'DAP' end,
                    color = function() return get_color_by_connection_status(_dap_status) end
                }
            }
        },
        extensions = {}
    })
end


return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = init
}
