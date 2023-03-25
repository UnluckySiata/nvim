local ok, cb = pcall(require, "codebuddy")
if not ok then return end

cb.setup()

vim.keymap.set("n", "<leader>rr", cb.run)
vim.keymap.set("n", "<leader>ra", cb.run_vsplit_args)
vim.keymap.set("n", "<leader>rv", cb.run_vsplit)
vim.keymap.set("n", "<leader>rs", cb.run_split)
vim.keymap.set("n", "<leader>rc", cb.compile)
