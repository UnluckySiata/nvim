local ok, neogit = pcall(require, "neogit")
if not ok then return end

local diffview = require("diffview")

vim.keymap.set("n", "<leader>gg", neogit.open)
vim.keymap.set("n", "<leader>gdd", diffview.open)
vim.keymap.set("n", "<leader>gdc", diffview.close)

neogit.setup({
    integrations = {
        diffview = true
    }
})
