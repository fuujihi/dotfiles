-- ====================================================
-- Telescope 設定 (fd 最適化版)
-- ====================================================
-- キーマッピング一覧:
-- ;f  - 高速ファイル検索 (隠しファイル含む)
-- ;F  - Git追跡ファイルのみ検索 (超高速)
-- ;af - 全ファイル検索 (.gitignore無視)
-- ;py - Pythonファイル検索
-- ;js - JavaScript/TypeScriptファイル検索
-- ;r  - 最近使用したファイル
-- ;g  - テキスト検索 (live grep)
-- ;h  - ヘルプ検索
-- ;e  - LSP診断情報
-- ;;  - 前回検索の再開
-- \\ - バッファ一覧
-- ====================================================

local status, telescope = pcall(require, "telescope")
if not status then
	return
end

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		winblend = 20,
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		mappings = {
			n = {
				["q"] = actions.close,
			},
		},
		file_ignore_patterns = {
			"%.git/", "node_modules/", "%.venv/", "htmlcov/",
			"%.mypy_cache/", "__pycache__/", "%.pyc$",
			"%.DS_Store", "%.localized", "%.tmp", "%.log"
		},
		-- fdのパフォーマンス設定
		file_previewer = require('telescope.previewers').vim_buffer_cat.new,
		grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
		qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
	},
	pickers = {
		find_files = {
			-- fd使用で高速化（.gitignore自動尊重、並列処理）
			find_command = {
				"fd",
				"--type", "f",
				"--hidden",
				"--follow",
				"--strip-cwd-prefix",
				"--exclude", ".git",
				"--exclude", "node_modules",
				"--exclude", ".venv",
				"--exclude", "htmlcov",
				"--exclude", "__pycache__",
				"--exclude", ".mypy_cache",
			},
		},
		live_grep = {
			additional_args = function(opts)
				return { "--hidden", "--glob", "!.git/**" }
			end,
		},
	},
	extensions = {},
})

-- 高速ファイル検索（通常使用、隠しファイル含む）
vim.keymap.set("n", ";f", function()
	builtin.find_files()
end)

-- Gitトラッキングファイルのみ検索（更に高速）
vim.keymap.set("n", ";F", function()
	builtin.git_files({
		show_untracked = true,
	})
end)

-- 全ファイル検索（.gitignore無視、最も広範囲）
vim.keymap.set("n", ";af", function()
	builtin.find_files({
		no_ignore = true,
		file_ignore_patterns = { ".git/**", "node_modules/**" },
	})
end)

-- 特定ファイルタイプ検索
vim.keymap.set("n", ";py", function()
	builtin.find_files({
		find_command = { "fd", "--extension", "py", "--strip-cwd-prefix" },
	})
end)

vim.keymap.set("n", ";js", function()
	builtin.find_files({
		find_command = { "fd", "--extension", "js", "--extension", "ts", "--extension", "jsx", "--extension", "tsx", "--strip-cwd-prefix" },
	})
end)

-- 最近使用したファイル
vim.keymap.set("n", ";r", function()
	builtin.oldfiles()
end)

-- テキスト検索
vim.keymap.set("n", ";g", function()
	telescope.extensions.egrepify.egrepify()
end)

-- バッファ一覧
vim.keymap.set("n", "\\\\", function()
	builtin.buffers()
end)

-- ヘルプ検索
vim.keymap.set("n", ";h", function()
	builtin.help_tags()
end)

-- LSP関連
vim.keymap.set("n", ";e", function()
	builtin.diagnostics()
end)

-- 検索履歴再開
vim.keymap.set("n", ";;", function()
	builtin.resume()
end)
