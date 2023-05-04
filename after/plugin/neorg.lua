local ok, neorg = pcall(require, "neorg")
if not ok then return end

neorg.setup({
    load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {
            config = {
                icon_preset = "diamond",
            },
        }, -- Adds pretty icons to your documents
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp",
            },
        },
        ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
                workspaces = {
                    notes = "~/notes",
                },
                default_workspace = "notes",
            },
        },
        ["core.integrations.telescope"] = {},
    },
})

vim.keymap.set("n", "<leader>ow", ":Neorg workspace<CR>", { silent = true })
vim.keymap.set("n", "<leader>oi", ":Neorg index<CR>", { silent = true })
vim.keymap.set("n", "<leader>or", ":Neorg return<CR>", { silent = true })

