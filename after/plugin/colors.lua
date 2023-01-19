if not pcall(require, "rose-pine") then
    return
end

function ColorSet(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    -- Transparency
    --vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    --vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

-- ColorSet('tokyonight-night')
ColorSet()
