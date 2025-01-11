return {
  {
    "stevearc/oil.nvim",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      local oil = require("oil")

      oil.setup()
      vim.keymap.set("n", "<leader>.", oil.open)
    end
  }
}
