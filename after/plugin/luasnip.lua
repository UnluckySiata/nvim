local ok, ls = pcall(require, 'luasnip')
if not ok then return end

vim.keymap.set({ "i", "s" }, "<c-s>", function ()
    if ls.expandable() then
        ls.expand()
    end
end, { silent = true })


