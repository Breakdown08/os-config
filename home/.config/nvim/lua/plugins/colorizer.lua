local function init()
    require("colorizer").setup({
        "*", -- для всех файлов
        go = {
            RGB = true, -- #RGB
            RRGGBB = true, -- #RRGGBB
            names = true, -- red, blue
            RRGGBBAA = true, -- #RRGGBBAA
            rgb_fn = true, -- rgb()
            hsl_fn = true, -- hsl()
            css = true,
            css_fn = true,

            -- главное: подсветка hex БЕЗ #
            mode = "background",
        },
    }, {
        mode = "background",
        css = true,
        css_fn = true,
        names = true,

        -- позволяет ловить "000000" внутри строк
        tailwind = false,
        sass = { enable = true },
        virtualtext = "■",
    })

    -- Включаем для текущего буфера автоматически
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        callback = function(args)
            require("colorizer").attach_to_buffer(args.buf)
        end,
    })
end

return {
    "NvChad/nvim-colorizer.lua",
    config = init,
}
