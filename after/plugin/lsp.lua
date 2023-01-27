local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local cmp_lsp = require("cmp_nvim_lsp")

mason.setup()
mason_lspconfig.setup({
    ensure_installed = {
        "sumneko_lua"
    }
})

local servers = {
    sumneko_lua = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

local capabilities = cmp_lsp.default_capabilities()

local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>cr", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.signature_help() end, opts)
end

mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup_handlers({
            settings = servers[server_name],
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end
})
