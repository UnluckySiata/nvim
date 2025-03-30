return {
    {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken",
    config = function ()
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
      copilot = {
        endpoint = "https://api.githubcopilot.com",
        model = "claude-3.5-sonnet",
        proxy = nil,
        allow_insecure = false,
        timeout = 20000,
        temperature = 0.1,
        max_tokens = 16384,
      },
      ollama = {
        model = "gemma3",
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
  }
}
