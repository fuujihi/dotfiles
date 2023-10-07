return {
    { -- onedark theme
        "navarasu/onedark.nvim",
        config = function() require('onedark').load() end,
    },
    { -- statusline
        "nvim-lualine/lualine.nvim",
        config = function() require('plugins.config.lualine') end,
    },
    { -- comment
        "numToStr/Comment.nvim",
        event = { 'InsertEnter', 'CursorMoved', 'CursorHold' },
        config = function() require('Comment').setup{} end,
    },
    { -- autopair
        'windwp/nvim-autopairs',
        event = { 'InsertEnter' },
        config = function() require('nvim-autopairs').setup{} end,
    },
    { -- git sign
        "lewis6991/gitsigns.nvim",
        config = function() require('gitsigns').setup{} end,
    },
    { -- indent line
        "lukas-reineke/indent-blankline.nvim", tag="v2.20.8",
        config = function()
            require('indent_blankline').setup()
        end,
    },
    { -- UI for messages, cmdline, popupmenu
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function() require('plugins.config.noice') end,
    },
    { -- termianl
        "akinsho/toggleterm.nvim",
        config = function() require('plugins.config.toggleterm') end,
    },
    { -- custom tab display
        "akinsho/nvim-bufferline.lua",
        config = function() require('plugins.config.bufferline') end,
    },
    { -- vscode-like pictograms
        'onsails/lspkind-nvim',
        config = function() require('plugins.config.lspkind') end,
    },
    { -- fuzzy finder
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons"
        },
        config = function() require('plugins.config.telescope') end,
    },
    { -- lsp
        'williamboman/mason.nvim',
        config = function() require('mason').setup() end,
    },
    { -- lsp config
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function() require('plugins.config.lspconfig') end,
    },
    { -- UI for LSP
        'glepnir/lspsaga.nvim',
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function() require('plugins.config.lspsaga') end,
    },
    { -- completion
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function() require('plugins.config.cmp') end,
    },
    {
        'fuujihi/vim-im-select',
        config = function()
            vim.api.nvim_exec([[let g:im_select_default = 'com.apple.keylayout.US']], true)
        end,
    } -- automatically change IM
}
