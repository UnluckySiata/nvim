if not pcall(require, 'harpoon') then
    return
end

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local term = require("harpoon.term")

vim.keymap.set("n", "<leader>a", mark.add_file)

vim.keymap.set("n", "<leader>pa", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>pp", ui.nav_prev)
vim.keymap.set("n", "<leader>pn", ui.nav_next)

for i = 1, 9 do
    vim.keymap.set("n", string.format("<leader>%s", i), function() ui.nav_file(i) end)
    vim.keymap.set("n", string.format("<leader>t%s", i), function() term.gotoTerminal(i) end)
end
