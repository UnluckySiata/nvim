local on_attach = function(_, bufnr)
  vim.lsp.inlay_hint.enable(true)

  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "gra", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "grr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover { border = "rounded" } end, opts)
  vim.keymap.set("i", "<c-s>", function() vim.lsp.buf.signature_help { border = "rounded" } end, opts)

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
  vim.keymap.set("n", "<leader>lk", function()
    vim.diagnostic.open_float {
      border = "rounded",
      source = true,
      scope = "line",
    }
  end, opts)
  vim.keymap.set("n", "[d", function()
    vim.lsp.diagnostic.goto_prev {
      float = {
        border = "rounded",
        source = true,
        scope = "line",
      }
    }
  end, opts)
  vim.keymap.set("n", "]d", function()
    vim.lsp.diagnostic.goto_next {
      float = {
        border = "rounded",
        source = true,
        scope = "line",
      }
    }
  end, opts)
end

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "folke/lazydev.nvim",
    },
    version = "*",

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",
        ["<c-l>"] = { "show", "show_documentation", "hide_documentation" },
        ["<c-k>"] = { "snippet_forward", "fallback" },
        ["<c-j>"] = { "snippet_backward", "fallback" },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono"
      },

      completion = {
        menu = {
          border = "rounded",
        },
        list = {
          selection = { preselect = false, auto_insert = true },
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },

      signature = {
        enabled = true,
        window = {
          border = "rounded",
        },
      },

      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "folke/lazydev.nvim",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local lspconfig = require("lspconfig")

      vim.diagnostic.config {
        virtual_text = false,
        inlay_hints = true,
      }

      local servers = {
        clangd = {
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
        lua_ls = {},
        rust_analyzer = {},
        gopls = {},
      }

      -- extend server config with lsp servers installed in custom dir
      for name, _ in vim.fs.dir("~/source/lsp/servers") do
        if pcall(require, "lspconfig.configs." .. name) then
          servers[name] = {}
        end
      end

      -- per-project lsp server setup
      local local_config = vim.fs.find(".nv/lsp.lua", {
        upward = true,
        stop = vim.uv.os_homedir(),
      })

      local file = local_config[1] -- first matching path or nil

      if file then
        local cfg = dofile(file)

        if cfg then
          -- overwrite with values from cfg on conflict
          servers = vim.tbl_deep_extend("force", servers, cfg)
        end
      end

      local default_settings = {
        capabilities = capabilities,
        on_attach = on_attach,
      }
      for name, settings in pairs(servers) do
        settings = vim.tbl_deep_extend("force", default_settings, settings)
        lspconfig[name].setup(settings)
      end

      local augroup = vim.api.nvim_create_augroup("lsp", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then return end

          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = { "*.go" },
            desc = "format file save (with lsp)",
            group = augroup,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = c.id, timeout_ms = 3000 })
            end
          })
        end
      })
    end
  }
}
