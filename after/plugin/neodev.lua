local ok, neodev = pcall(require, "neodev")
if not ok then return end

neodev.setup({
    library = {
        plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
    },
    override = function(root_dir, library)
        library.enabled = true
        library.plugins = true
    end,
})
