local ok, ls = pcall(require, "luasnip")
if not ok then return end

local cmp = require("cmp")

require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set({ "i", "s" }, "<c-k>", function ()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    else
        cmp.confirm({ select = true })
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function ()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

