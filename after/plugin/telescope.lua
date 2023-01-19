if not pcall(require, 'telescope') then
    return
end

local builtin = require('telescope.builtin')

-- Buffers
vim.keymap.set('n', '<leader>bi', builtin.buffers, {})

-- Project
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pgf', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})

-- LSP
vim.keymap.set('n', '<leader>lr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>li', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>lgd', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>ld', builtin.diagnostics, {})

-- Treesitter
vim.keymap.set('n', '<leader>ts', builtin.treesitter, {})

-- Git
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})

