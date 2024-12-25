return {
  {
    "stevearc/oil.nvim",
    ---@module "oil"
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { "echasnovski/mini.icons" },
    setup = function()
      vim.keymap.set("n", "<leader>.", require("oil").open)
    end
  }
}
