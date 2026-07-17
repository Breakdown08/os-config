local mason_packages = {}

for _, lang in pairs(allowed_languages) do
    table.insert(mason_packages, lang.name)
end

return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate", -- Критически важно для первоначальной установки
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = mason_packages,
                automatic_installation = true,
            })
        end,
        dependencies = { "williamboman/mason.nvim" }
    }
}