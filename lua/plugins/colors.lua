return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup {
        variant = "main",

        styles = {
          bold = true,
          italic = false,
          transparency = true
        },
      }
      vim.cmd("colorscheme rose-pine")

      -- transparency fixes
      vim.api.nvim_set_hl(0, "Winbar", { fg = "#f6c177", bg = "none" })
      vim.api.nvim_set_hl(0, "WinbarNC", { fg = "#f6c177", bg = "none" })
      vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#cb99c9", bg = "none", blend = 10 })
    end
  }
}
