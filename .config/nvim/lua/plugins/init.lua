return {
	{ -- which-key for keybinding hints
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({
				delay = 300,
				icons = {
					mappings = false,
				},
			})
			wk.add({
				{ ";", group = "Search/Tools" },
				{ "s", group = "Window/Split" },
				{ "t", group = "Tab" },
			})
		end,
	},
	{ -- flash.nvim for quick navigation
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{ "gs", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
			{ "gS", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
		},
	},
	{ -- onedark theme
		"navarasu/onedark.nvim",
		priority = 1000, -- テーマは最優先で読み込み
		lazy = false,
		config = function()
			require("onedark").load()
		end,
	},
	{ -- statusline
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy", -- 初期化後に読み込み
		config = function()
			require("plugins.config.lualine")
		end,
	},
	{ -- comment
		"numToStr/Comment.nvim",
		keys = { "gc", "gb" }, -- キー入力時に読み込み
		config = function()
			require("Comment").setup({})
		end,
	},
	{ -- autopair
		"windwp/nvim-autopairs",
		event = "InsertEnter", -- 挿入モードで読み込み
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{ -- git sign
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" }, -- ファイル読み込み時
		config = function()
			require("gitsigns").setup({})
		end,
	},
	{ -- indent line
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" }, -- バッファ読み込み後
		main = "ibl",
		opts = {},
	},
	{ -- UI for messages, cmdline, popupmenu
		"folke/noice.nvim",
		event = "VeryLazy", -- 初期化後に読み込み
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("plugins.config.noice")
		end,
	},
	{ -- terminal
		"akinsho/toggleterm.nvim",
		keys = { ";;" }, -- キー入力時に読み込み
		config = function()
			require("plugins.config.toggleterm")
		end,
	},
	-- bufferlineを削除してlualineのtablineを使用
	{ -- vscode-like pictograms
		"onsails/lspkind-nvim",
		lazy = true, -- 他のプラグインから呼ばれる時に読み込み
		config = function()
			require("plugins.config.lspkind")
		end,
	},
	{ -- fuzzy finder
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope", -- コマンド実行時に読み込み
		keys = { ";f", ";g", "\\\\" }, -- キー入力時に読み込み
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"fdschmidt93/telescope-egrepify.nvim",
		},
		config = function()
			require("plugins.config.telescope")
		end,
	},
	{ -- lsp (Mason + 新しいvim.lsp.config)
		"williamboman/mason.nvim",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		lazy = false, -- 起動時に読み込み
		priority = 700, -- 高優先度
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- LSP設定ファイルを読み込み（新しいvim.lsp.config方式）
			require("plugins.config.lspconfig")
		end,
	},
	{ -- treesitter for better syntax highlighting
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" }, -- ファイル読み込み時に遅延読み込み
		priority = 800,
		build = ":TSUpdate",
		config = function()
			-- 安全な遅延読み込み
			vim.defer_fn(function()
				local ok, err = pcall(require, "plugins.config.treesitter")
				if not ok then
					vim.notify("Treesitter設定をスキップしました: " .. (err or "unknown"), vim.log.levels.INFO)
				end
			end, 100)
		end,
	},
	{ -- UI for LSP
		"glepnir/lspsaga.nvim",
		event = "LspAttach", -- LSP起動時
		config = function()
			-- lspsaga設定を直接読み込み
			require("plugins.config.lspsaga")
		end,
	},
	{ -- completion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- 挿入モード時
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			require("plugins.config.cmp")
		end,
	},
	{
		"fuujihi/vim-im-select",
		event = "InsertEnter", -- 挿入モード時
		config = function()
			vim.api.nvim_exec([[let g:im_select_default = 'com.apple.keylayout.US']], true)
		end,
	}, -- automatically change IM
	{ -- file tree
		"nvim-tree/nvim-tree.lua",
		lazy = false, -- 起動時に即座に読み込み
		priority = 900, -- テーマの次に読み込み
		keys = ";t", -- 手動トグル用
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("plugins.config.nvim-tree")
			-- 設定後すぐにツリーを開く
			require("nvim-tree.api").tree.open()
			-- UIが準備完了後にフォーカスを編集ペインに移動
			vim.api.nvim_create_autocmd("UIEnter", {
				once = true,
				callback = function()
					vim.cmd("wincmd l")
				end,
			})
		end,
	},
    {
        "github/copilot.vim",
        event = "InsertEnter", -- 挿入モード時
        config = function()
            vim.g.copilot_filetypes = {markdown = true}
		end,
    },
}
