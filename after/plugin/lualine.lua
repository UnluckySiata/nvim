local ok, lualine = pcall(require, "lualine")
if not ok then return end

lualine.setup({
    options = {
        theme = "seoul256",
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = { "filetype" },
        lualine_z = { "location" },
    },
})
