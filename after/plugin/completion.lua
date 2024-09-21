local ok, cmp = pcall(require, "cmp")
if not ok then return end

local lspkind = require("lspkind")

cmp.setup {
    mapping = cmp.mapping.preset.insert {
        ["<c-b>"] = cmp.mapping.scroll_docs(-4),
        ["<c-f>"] = cmp.mapping.scroll_docs(4),
        ["<c-e>"] = cmp.mapping.abort(),
        ["<c-l>"] = function ()
            if cmp.visible_docs() then
                cmp.close_docs()
            else
                cmp.open_docs()
            end
        end,
        ["<c-p>"] = cmp.mapping.select_prev_item(),
        ["<c-n>"] = cmp.mapping.select_next_item(),
        ["<c-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        ["<c-space>"] = cmp.mapping.complete(),
    },

    sources = cmp.config.sources {
        { name = "nvim_lua", priority = 10 },
        { name = "nvim_lsp", priority = 5},
        { name = "path" },
        { name = "luasnip" },
        { name = "neorg" },
        { name = "buffer", keyword_length = 4 },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    preselect = "None";

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end
    },

    view = {
        docs = {
            auto_open = false,
        },
    },

    formatting = {
        expandable_indicator = true,
        fields = { "abbr", "kind", "menu" },

        format = lspkind.cmp_format({
            with_text = true,
            maxwidth = function() return math.floor(0.4 * vim.o.columns) end,
            ellipsis_char = "..",
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                neorg = "[neorg]",
                luasnip = "[snip]",
            }
        })
    },
}

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" }
    }
})
