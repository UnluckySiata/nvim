local ok, oil = pcall(require, "oil")
if not ok then return end

oil.setup()

vim.keymap.set("n", "<leader>.", oil.open)

