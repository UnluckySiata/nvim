local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

local cmp_lsp = require("cmp_nvim_lsp")
local lsp_lines = require("lsp_lines")

lsp_lines.setup()

local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, opts)
    vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>lc", vim.lsp.codelens.run, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    -- format file
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format { async = true }
    end, opts)
    -- format selection
    vim.keymap.set("v", "<leader>f", function()
        vim.lsp.buf.format {
            async = true,
            range = {
                ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
                ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
            }
        }
    end, opts)

    -- diagnostics
    vim.keymap.set("n", "<leader>ltl", lsp_lines.toggle, opts)
    vim.keymap.set("n", "<leader>lk", function()
        vim.diagnostic.open_float {
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "line",
        }
    end, opts)
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.goto_prev {
            float = {
                border = "rounded",
                source = "always",
                prefix = " ",
                scope = "line",
            }
        }
    end, opts)
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.goto_next {
            float = {
                border = "rounded",
                source = "always",
                prefix = " ",
                scope = "line",
            }
        }
    end, opts)
end

-- server configurations
local capabilities = cmp_lsp.default_capabilities()
local servers = {
    rust_analyzer = {},
    gopls = {},
    nixd = {},
    pyright = {},
    jdtls = {},
    elixirls = {},
    erlangls = {},

    html = {},
    htmx = {},
    templ = {},

    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT"
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME
                    }
                }
            }
        }

    },

    clangd = {
        cmd = {
            "clangd",
            "--all-scopes-completion",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--fallback-style=Google",
            "--function-arg-placeholders",
            "--header-insertion=iwyu",
            "--header-insertion-decorators",
        }
    }
}

for name, cfg in pairs(servers) do
    local base_config = {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    local config = vim.tbl_deep_extend("force", base_config, cfg)

    lspconfig[name].setup(config)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
)

vim.diagnostic.config({
    virtual_text = false,
    inlay_hints = true,
})
