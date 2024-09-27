local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local cmp_lsp = require("cmp_nvim_lsp")
local lsp_lines = require("lsp_lines")

require("neodev").setup {
    override = function(_, library)
        library.enabled = true
        library.plugins = true
    end,
}

mason.setup {
    ui = {
        border = "rounded"
    }
}
mason_lspconfig.setup {
    ensure_installed = {
        "lua_ls"
    }
}

lsp_lines.setup()
lsp_lines.toggle()

local capabilities = cmp_lsp.default_capabilities()

local on_attach = function(_, bufnr)
    vim.lsp.inlay_hint.enable(true)

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, opts)
    vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<c-h>", vim.lsp.buf.signature_help, opts)
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

local servers = {
    lua_ls = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    },
}

local local_servers = {
    clangd = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {
            "c", "cpp"
        },
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
    },
    rust_analyzer = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    gopls = {
        capabilities = capabilities,
        on_attach = on_attach,
    }
}


-- per-project lsp server setup
local local_config = vim.fs.find(".nv/lsp.lua", {
    upward = true,
    stop = vim.loop.os_homedir(),
})

local file = local_config[1] -- first matching path or nil

if file then
    local cfg = dofile(file)

    if cfg then
        -- overwrite with values from cfg on conflict
        servers = vim.tbl_deep_extend("force", servers, cfg)
        local_servers = vim.tbl_deep_extend("force", servers, cfg)
    end
end


mason_lspconfig.setup_handlers {
    function(server_name)
        lspconfig[server_name].setup({
            settings = servers[server_name] or {},
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end
}

for name, settings in pairs(local_servers) do
    lspconfig[name].setup(settings)
end


local augroup = vim.api.nvim_create_augroup("lsp", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go" },
    desc = "format file save (with lsp)",
    group = augroup,
    callback = function(_)
        vim.lsp.buf.format({ timeout_ms = 3000 })
    end
})
