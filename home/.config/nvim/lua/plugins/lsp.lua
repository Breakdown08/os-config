local function _update_lsp_status()
    local clients = vim.lsp.get_clients({ bufnr = 0 }) -- Для текущего буфера
    local active = (#clients > 0) and ConnectionStatus.ACTIVE or ConnectionStatus.DISABLED
	events.get(Event.LSP_STATUS_CHANGED):emit(active)
end


local function init()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    for _, lang in pairs(allowed_languages) do
        vim.lsp.config(lang.name, lang:get_lsp_config())
        vim.lsp.enable(lang.name)
    end
    vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
        callback = _update_lsp_status,
    })
end


return {
    "neovim/nvim-lspconfig",
    config = init,
    dependencies = {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp"
    }
}
