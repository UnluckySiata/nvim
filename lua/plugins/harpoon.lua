return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<leader>pa", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      for i = 1, 9 do
        vim.keymap.set("n", string.format("<leader>%s", i), function() harpoon:list():select(i) end)
      end

      vim.keymap.set("n", "<c-s-p>", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<c-s-n>", function() harpoon:list():next() end)
    end
  }
}
