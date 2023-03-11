local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim'                     -- plugin manager
  use 'nvim-lua/plenary.nvim'                      -- common utilities
  use 'nvim-lualine/lualine.nvim'                  -- statusline
  use 'windwp/nvim-autopairs'                      -- autopair
  use 'kyazdani42/nvim-web-devicons'               -- file icons
  use 'nvim-telescope/telescope.nvim'              -- fuzzy finder
  use 'nvim-telescope/telescope-file-browser.nvim' -- file browser
  use 'navarasu/onedark.nvim'                      -- onedark theme
  use 'numToStr/Comment.nvim'                      -- comment
  use 'fuujihi/vim-im-select'                      -- automatically change IM
  use 'lewis6991/gitsigns.nvim'                    -- view git diffs
  use 'akinsho/toggleterm.nvim'                    -- terminal
  use 'akinsho/nvim-bufferline.lua'                -- custom tab display
  use 'lukas-reineke/indent-blankline.nvim'        -- display indent
  use 'onsails/lspkind-nvim'                       -- vscode-like pictograms
  use 'hrsh7th/nvim-cmp'                           -- completion
  use 'hrsh7th/cmp-buffer'                         -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-cmdline'                        -- nvim-cmp source for cmdline
  use 'hrsh7th/cmp-nvim-lsp'                       -- nvim-cmp source for neovim's built-in LSP
  use 'glepnir/lspsaga.nvim'                       -- UI for LSP
  use {
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim'
  } -- lsp
  use({
    "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  }) -- UI for messages, cmdline, popupmenu
end)
