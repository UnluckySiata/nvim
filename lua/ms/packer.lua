
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath "data".."/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
        print "Installing plugin manager.."
        vim.cmd.packadd("packer.nvim")
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()
local packer = require("packer")

return packer.startup(function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    -- Colorschemes
    use "folke/tokyonight.nvim"
    use({
        "rose-pine/neovim",
        as = "rose-pine"
    })
    use { "catppuccin/nvim", as = "catppuccin" }
    use { "Shatur/neovim-ayu", as = "ayu" }

    use "kyazdani42/nvim-web-devicons"

    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            { "kyazdani42/nvim-web-devicons", opt = true },
        }
    }

    use {
        "nvim-telescope/telescope.nvim", branch = "0.1.x",
        requires = {
            "nvim-lua/plenary.nvim",
            {"nvim-telescope/telescope-fzf-native.nvim", run = "make" },
            "nvim-telescope/telescope-ui-select.nvim",
        }
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            pcall(require("nvim-treesitter.install").update({ with_sync = true }))
        end
    }

    use "theprimeagen/harpoon"
    use "mbbill/undotree"
    use "ggandor/leap.nvim"
    use "numToStr/Comment.nvim"
    use "kylechui/nvim-surround"
    use "windwp/nvim-autopairs"
    use "vale1410/vim-minizinc"
    use "ellisonleao/glow.nvim"

    use {
        "j-hui/fidget.nvim",
        tag = "legacy",
    }

    -- filesystem management
    use "stevearc/oil.nvim"

    -- git
    use {
        "NeogitOrg/neogit",
        requires = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "lewis6991/gitsigns.nvim"
        }
    }

    -- note taking
    use {
        "nvim-neorg/neorg",
        run = ":Neorg sync-parsers",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neorg/neorg-telescope",
        },
    }

    -- LSP
    use {
        "neovim/nvim-lspconfig",
        requires = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- Neovim development
            "folke/neodev.nvim",
        }
    }
    use {
        "elixir-tools/elixir-tools.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        }
    }


    -- Completion
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",

            -- Snippet engine
            { "L3MON4D3/LuaSnip", tag = "v1.*" },
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",

            -- Looks
            "onsails/lspkind.nvim",
        }
    }

    use "unluckysiata/codebuddy.nvim"

    if packer_bootstrap then
        print "Installing plugins.."
        packer.sync()
    end

end)
