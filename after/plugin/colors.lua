if not pcall(require, "rose-pine") then
    return
end

require("rose-pine").setup({
    dark_variant = "main",
    disable_background = true,
    disable_float_background = true,
    disable_italics = true
})

function ColorSet(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    -- Transparency
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

-- ColorSet("tokyonight-night")
ColorSet()
