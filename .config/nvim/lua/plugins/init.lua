vim.cmd [[packadd packer.nvim]]

local status, packer = pcall(require, "packer")
if (not status) then
    print("Packer is not installed")
    return
end

vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])

return packer.startup(function(use)
    use { 'wbthomason/packer.nvim', opt = true } -- plugin manager

    use 'nvim-lua/plenary.nvim' -- common utilities

    use {
        'nvim-lualine/lualine.nvim',
        config = function() require('plugins.config.lualine') end,
    } -- statusline

    use {
        'kyazdani42/nvim-web-devicons',
        config = function() require('nvim-web-devicons').setup{} end,
    } -- file icons

    use {
        'nvim-telescope/telescope.nvim',
        module   = { "telescope" },
        event    = { 'VimEnter' },
        requires = { 'nvim-telescope/telescope-file-browser.nvim', opt = true },
        wants    = { 'telescope-file-browser.nvim' },
        config   = function() require('plugins.config.telescope') end,
    } -- fuzzy finder

    use {
        'navarasu/onedark.nvim',
        config = function() require('onedark').load() end,
    } -- onedark theme

    use {
        'lewis6991/gitsigns.nvim',
        event  = { 'InsertEnter', 'CursorMoved', 'CursorHold' },
        config = function() require('gitsigns').setup{} end,
    } -- view git diffs

    use {
        'akinsho/toggleterm.nvim',
        event  = { 'VimEnter' },
        config = function() require('plugins.config.toggleterm') end,
    } -- terminal

    use {
        'akinsho/nvim-bufferline.lua',
        config = function() require('plugins.config.bufferline') end,
    } -- custom tab display

    use {
        'onsails/lspkind-nvim',
        config = function() require('plugins.config.lspkind') end,
    } -- vscode-like pictograms

    use {
        "lukas-reineke/indent-blankline.nvim",
        setup = function()
            vim.opt.list = true
            vim.cmd [[highlight IndentBlanklineIndent guifg=#3E4452 gui=nocombine]]
        end,
        config = function() require('indent_blankline').setup{} end,
    } -- indent line

    use {
        'hrsh7th/nvim-cmp',
        module   = { 'cmp' },
        requires = {
            { 'hrsh7th/cmp-buffer',   event = { 'InsertEnter' } },
            { 'hrsh7th/cmp-cmdline',  event = { 'InsertEnter' } },
            { "hrsh7th/cmp-nvim-lsp", event = { "VimEnter" } },
        },
        config = function() require('plugins.config.cmp') end,
    } -- completion

    use {
        'glepnir/lspsaga.nvim',
        config = function() require('plugins.config.lspsaga') end,
    } -- UI for LSP

    use {
        'windwp/nvim-autopairs',
        event = { 'InsertEnter' },
        config = function() require('nvim-autopairs').setup{} end,
    } -- autopair

    use {
        'numToStr/Comment.nvim',
        event = { 'InsertEnter', 'CursorMoved', 'CursorHold' },
        config = function() require('Comment').setup{} end,
    } -- comment

    use {
        'fuujihi/vim-im-select',
        event = { 'InsertEnter' },
        setup = function()
            vim.api.nvim_exec([[let g:im_select_default = 'com.apple.keylayout.US']], true)
        end,
    } -- automatically change IM

    use {
        'neovim/nvim-lspconfig',
        event = { "VimEnter" },
        config = function() require('plugins.config.lspconfig') end,
    } -- lsp

    use 'hrsh7th/cmp-nvim-lsp'

    use {
        'williamboman/mason.nvim',
        config = function() require('mason').setup() end,
    } -- lsp

    use {
        'williamboman/mason-lspconfig.nvim',
        config = function() require('mason-lspconfig').setup() end,
    } -- lsp config

    use({
        "folke/noice.nvim",
        event = { 'VimEnter' },
        requires = {
            { 'MunifTanjim/nui.nvim', opt = true },
            { 'rcarriga/nvim-notify', opt = true },
        },
        wants  = { 'nui.nvim', 'nvim-notify' },
        config = function() require('plugins.config.noice') end,
    }) -- UI for messages, cmdline, popupmenu

    use {
        'nvim-treesitter/nvim-treesitter',
        event = { 'VimEnter' },
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
end)
