return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      integrations = {
        telescope = true,
        diffview = true,
      }
    },
    config = function()
      vim.keymap.set("n", "<leader>gg", require("neogit").open)
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local function set_git_highlights()
        vim.api.nvim_set_hl(0, "GitSignsAddPreview", { bg = "#2d4a2b", fg = "#a6e3a1" })
        vim.api.nvim_set_hl(0, "GitSignsDeletePreview", { bg = "#4a2d2d", fg = "#f38ba8" })
        vim.api.nvim_set_hl(0, "GitSignsChangePreview", { bg = "#3d3a2b", fg = "#f9e2af" })
        vim.api.nvim_set_hl(0, "GitSignsAddInline", { bg = "#4a5d23", fg = "#a6e3a1", bold = true })
        vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { bg = "#5d2323", fg = "#f38ba8", bold = true })
        vim.api.nvim_set_hl(0, "GitSignsChangeInline", { bg = "#5d4a23", fg = "#f9e2af", bold = true })
      end

      set_git_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_git_highlights })

      local gs = require("gitsigns")
      gs.setup {
        preview_config = {
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
          title = "Git Hunk Preview",
          title_pos = "center"
        },
        diff_opts = {
          internal = true,
          linematch = 60,
        },
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 50,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        current_line_blame_formatter = function(_, blame_info, _)
          if blame_info.author == "Not Committed Yet" then
            return { { " Uncommitted changes", "GitSignsCurrentLineBlame" } }
          end

          local author = blame_info.author
          local date = os.date("%Y-%m-%d", blame_info.author_time)
          local summary = blame_info.summary
          local sha = blame_info.abbrev_sha

          return {
            { " [", "Comment" },
            { sha, "Number" },
            { "] ", "Comment" },
            { author, "String" },
            { " • ", "Comment" },
            { date, "Special" },
            { " • ", "Comment" },
            { summary, "Comment" },
          }
        end,
        signs = {
          add          = { text = "┃" },
          change       = { text = "┃" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
          untracked    = { text = "┆" },
        },
        on_attach = function(bufnr)
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gs.nav_hunk("next")
            end
          end)

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end)

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk)
          map("n", "<leader>hr", gs.reset_hunk)
          map("v", "<leader>hs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end)
          map("v", "<leader>hr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end)
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk_inline)
          map("n", "<leader>hb", function() gs.blame_line { full = true } end)
          map("n", "<leader>htb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function() gs.diffthis("~") end)
        end
      }
    end
  }
}
