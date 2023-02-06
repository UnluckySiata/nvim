function ColorSet(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    -- Transparency
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

local ok, rosepine = pcall(require, "rose-pine")
if not ok then return end

rosepine.setup({
    dark_variant = "main",
    disable_background = true,
    disable_float_background = true,
    disable_italics = true
})

local ayu
ok, ayu = pcall(require, "ayu")
if ok then
    ayu.setup({
        disable_background = true,
        disable_float_background = true,
        disable_italics = true
    })
end

local tokyonight
ok, tokyonight = pcall(require, "tokyonight")
if ok then
    tokyonight.setup({
        style = "moon",
        transparent = true,
    })
end

local catppuccin
ok, catppuccin = pcall(require, "catppuccin")
if ok then
    catppuccin.setup({
        flavor = "mocha",
        transparent_background = true,
        no_italic = true,
    })
end


-- ColorSet("tokyonight-night")
-- ColorSet("catppuccin")
ColorSet()
