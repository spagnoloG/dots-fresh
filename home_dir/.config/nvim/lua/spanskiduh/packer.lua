-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use {'wbthomason/packer.nvim'}

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = function()
            require('spanskiduh.telescope')
        end
    }

    use { 'navarasu/onedark.nvim',
        config = function()
            require('onedark').setup()
        end
    }

    use ('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})

    use ( 'nvim-treesitter/playground' )

    use { 'theprimeagen/harpoon' ,
        config = function()
            require('spanskiduh.harpoon')
        end
    }

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
        },
        config = function()
            require('spanskiduh.lsp')
        end
    }

    use {
        'lervag/vimtex',
        -- load config from file
        config = function()
            require('spanskiduh.vimtex')
        end
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
        config = function()
            require('spanskiduh.neotree')
        end
    }

    -- Projects detection
    use {"ahmedkhalf/project.nvim"}

    -- Git signs
    use { 'lewis6991/gitsigns.nvim',
        config = function()
            require('spanskiduh.gitsigns')
        end
    }

end)
