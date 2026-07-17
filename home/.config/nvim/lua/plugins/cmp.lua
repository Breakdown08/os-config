local function init()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },  -- Источник LSP
            { name = 'luasnip' },   -- Источник сниппетов
        }, {
            --{ name = 'buffer' },    -- Автодополнение из текущего буфера
            { name = 'path' }       -- Автодополнение путей
        }),
        formatting = {
            format = function(entry, vim_item)
                local icons = {}
                vim_item.kind = string.format('%s %s', icons[vim_item.kind] or '', vim_item.kind)
                return vim_item
            end
        }
    })
end

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",    -- Интеграция с LSP
        "hrsh7th/cmp-buffer",      -- Автодополнение из буфера
        "hrsh7th/cmp-path",        -- Автодополнение путей
        "L3MON4D3/LuaSnip",        -- Сниппеты
        "saadparwaiz1/cmp_luasnip" -- Интеграция сниппетов с CMP
    },
    config = init,
    event = "InsertEnter"  -- Загружаем только при входе в режим вставки
}
