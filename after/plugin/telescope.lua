local ok, telescope = pcall(require, "telescope")
if not ok then return end

local builtin = require("telescope.builtin")

telescope.setup({
    defaults = {
        layout_strategy = "horizontal",

        layout_config = {

          horizontal = {
            height = 0.9,
            preview_cutoff = 120,
            prompt_position = "top",
            width = 0.8
          },

      },
      sorting_strategy = "ascending",
    },

    extensions = {
        file_browser = {
            grouped = true,
            previewer = false,
            hijack_netrw = true,
            theme = "dropdown"
        },
    },
})

telescope.load_extension("fzf")
telescope.load_extension("file_browser")
telescope.load_extension("ui-select")

-- Vim
vim.keymap.set("n", "<leader>vh", builtin.help_tags)
vim.keymap.set("n", "<leader>vmh", builtin.man_pages)
vim.keymap.set("n", "<leader>vk", builtin.keymaps)

-- Buffers
vim.keymap.set("n", "<leader>bi", builtin.buffers)

-- Project
vim.keymap.set("n", "<leader>pf", builtin.find_files)
vim.keymap.set("n", "<leader>pgf", builtin.git_files)
vim.keymap.set("n", "<leader>ps", builtin.live_grep)
vim.keymap.set("n", "<leader>.", telescope.extensions.file_browser.file_browser)
-- Git
vim.keymap.set("n", "<leader>pc", builtin.git_commits)
vim.keymap.set("n", "<leader>pb", builtin.git_branches)
vim.keymap.set("n", "<leader>ps", builtin.git_status)

-- LSP
vim.keymap.set("n", "<leader>lr", builtin.lsp_references)
vim.keymap.set("n", "<leader>li", builtin.lsp_implementations)
vim.keymap.set("n", "<leader>lgd", builtin.lsp_definitions)
-- Workspace diagnostics
vim.keymap.set("n", "<leader>ld", builtin.diagnostics)
-- Current file diagnostics
vim.keymap.set("n", "<leader>lfd", function() builtin.diagnostics({ bufnr=0 }) end)

-- Treesitter
vim.keymap.set("n", "<leader>ts", builtin.treesitter)

