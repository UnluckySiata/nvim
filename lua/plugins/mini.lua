return {
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.statusline").setup()
      require("mini.surround").setup()
      require("mini.icons").setup()
    end
  }
}
