-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = require('spanskiduh.telescope')
    }

    use { 'navarasu/onedark.nvim',
    config = require("spanskiduh.onedark")
    }

    use ('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})

    use ( 'nvim-treesitter/playground' )
    use ( 'theprimeagen/harpoon' )
    use ( 'mbbill/undotree' )
    use ( 'tpope/vim-fugitive' )

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    use {
        'lervag/vimtex',
        -- load config from file
        config = require('spanskiduh.vimtex')
    }

    -- Snippets
    use {"L3MON4D3/LuaSnip"}
    use "rafamadriz/friendly-snippets"

    -- Neotree
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = require('spanskiduh.neotree'),
    }

    -- Projects detection
    use {"ahmedkhalf/project.nvim"}

    -- Git signs
    use { 'lewis6991/gitsigns.nvim',
        config = require('spanskiduh.gitsigns')}

end)
