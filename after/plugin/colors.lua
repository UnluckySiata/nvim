function ColorSet(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    -- transparency fixes
    vim.api.nvim_set_hl(0, "Winbar", { fg = "#f6c177", bg = "none" })
    vim.api.nvim_set_hl(0, "WinbarNC", { fg = "#f6c177", bg = "none" })

end

local ok, rosepine = pcall(require, "rose-pine")
if not ok then return end

rosepine.setup({
    variant = "main",

    styles = {
        bold = true,
        italic = false,
        transparency = true
    },
})


ColorSet()
