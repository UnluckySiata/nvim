return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },

    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup {
        defaults = {
          layout_strategy = "horizontal",
          sorting_strategy = "ascending",

          layout_config = {
            horizontal = {
              height = 0.9,
              preview_cutoff = 120,
              prompt_position = "top",
              width = 0.8
            },
          },
        },

        pickers = {
          find_files = {
            theme = "ivy"
          },
        },

        extensions = {
          fzf = {}
        },
      }

      telescope.load_extension("fzf")

      -- Vim
      vim.keymap.set("n", "<leader>vh", builtin.help_tags)
      vim.keymap.set("n", "<leader>vmh", builtin.man_pages)
      vim.keymap.set("n", "<leader>vk", builtin.keymaps)

      -- Buffers
      vim.keymap.set("n", "<leader>bi", builtin.buffers)
      vim.keymap.set("n", "<leader>bs", builtin.current_buffer_fuzzy_find)
      vim.keymap.set("v", "<leader>bs", "\"fy:Telescope current_buffer_fuzzy_find default_text=<C-r>f<CR>")

      -- Project
      vim.keymap.set("n", "<leader>pf", builtin.find_files)
      vim.keymap.set("n", "<leader>pgf", builtin.git_files)
      vim.keymap.set("n", "<leader>ps", builtin.live_grep)
      vim.keymap.set("v", "<leader>ps", "\"gy:Telescope live_grep default_text=<C-r>g<CR>")
      -- Git
      vim.keymap.set("n", "<leader>pgc", builtin.git_commits)
      vim.keymap.set("n", "<leader>pgb", builtin.git_branches)
      vim.keymap.set("n", "<leader>pgs", builtin.git_status)

      -- LSP
      vim.keymap.set("n", "<leader>lgr", builtin.lsp_references)
      vim.keymap.set("n", "<leader>lgi", builtin.lsp_implementations)
      vim.keymap.set("n", "<leader>lgd", builtin.lsp_definitions)
      -- Workspace diagnostics
      vim.keymap.set("n", "<leader>ld", builtin.diagnostics)
      -- Current file diagnostics
      vim.keymap.set("n", "<leader>lfd", function() builtin.diagnostics({ bufnr = 0 }) end)

      -- Treesitter
      vim.keymap.set("n", "<leader>ts", builtin.treesitter)
    end
  }
}
