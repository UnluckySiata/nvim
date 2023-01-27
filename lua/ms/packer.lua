
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        print 'Installing plugin manager..'
        vim.cmd.packadd('packer.nvim')
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Colorschemes
    use('folke/tokyonight.nvim')
    use({
        'rose-pine/neovim',
        as = 'rose-pine'
    })

    use('kyazdani42/nvim-web-devicons')

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end
    }

    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use('ggandor/leap.nvim')
    use('kdheepak/lazygit.nvim')
    use('numToStr/Comment.nvim')
    use('kylechui/nvim-surround')
    use('windwp/nvim-autopairs')
    use('vale1410/vim-minizinc')

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        requires = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        }
    }

    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp',

            -- Snippet engine
            { "L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*" },
            'saadparwaiz1/cmp_luasnip'
        }
    }

    if packer_bootstrap then
        print 'Installing plugins..'
        require('packer').sync()
    end

end)
