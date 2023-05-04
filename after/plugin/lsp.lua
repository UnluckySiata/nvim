local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local cmp_lsp = require("cmp_nvim_lsp")

require("neodev").setup {
    override = function(_, library)
        library.enabled = true
        library.plugins = true
    end,
}

mason.setup()
mason_lspconfig.setup({
    ensure_installed = {
        "lua_ls"
    }
})

local servers = {
    lua_ls = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    },
}

local capabilities = cmp_lsp.default_capabilities()

local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>gtd", vim.lsp.buf.type_definition, opts)
    vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format { async = true }
    end, opts)

    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local window_opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = "rounded",
                source = "always",
                prefix = " ",
                scope = "cursor",
            }
            vim.diagnostic.open_float(nil, window_opts)
        end
    })
end

mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            settings = servers[server_name] or {},
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end
})

lspconfig.metals.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

vim.diagnostic.config({
    virtual_text = true,
})
