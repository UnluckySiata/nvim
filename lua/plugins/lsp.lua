local on_attach = function(_, bufnr)
  vim.lsp.inlay_hint.enable(true)

  local opts = { buffer = bufnr, remap = false }

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
    vim.diagnostic.goto_prev {
      float = {
        border = "rounded",
        source = true,
        scope = "line",
      }
    }
  end, opts)
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next {
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
      keymap = { preset = "default" },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono"
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

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = "rounded" }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = "rounded" }
      )

      vim.diagnostic.config {
        virtual_text = false,
        inlay_hints = true,
      }

      local servers = {
        lua_ls = {
          capabilities = capabilities,
          on_attach = on_attach,
        },
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
        end
      end

      for name, settings in pairs(servers) do
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
