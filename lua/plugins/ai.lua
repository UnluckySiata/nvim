return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken",
    config = function()
      local chat = require("CopilotChat")
      chat.setup {
        model = "o1",
      }
      vim.keymap.set("n", "<leader>ac", chat.toggle)
    end
  },
  {
    "yetone/avante.nvim",
    enabled = true,
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      -- provider = "copilot",
      provider = "ollama",
      providers = {
        copilot = {
          model = "claude-3.5-sonnet",
        },
        ollama = {
          model = "gemma3",
        },
      },
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      "echasnovski/mini.icons",
      "zbirenbaum/copilot.lua",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      ---@module "snacks"
      "folke/snacks.nvim"
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {}

      local oc = require("opencode")

      vim.keymap.set({ "n", "t" }, "<leader>ot", function() oc.toggle() end, { desc = "Toggle opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>oa", function() oc.ask("@this: ", { submit = true }) end,
        { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>ox", function() oc.select() end,
        { desc = "Execute opencode action…" })

      vim.keymap.set({ "n", "x" }, "<leader>or", function() return oc.operator("@this ") end,
        { expr = true, desc = "Add range to opencode" })
      vim.keymap.set("n", "<leader>ol", function() return oc.operator("@this ") .. "_" end,
        { expr = true, desc = "Add line to opencode" })
    end,
  }
}
