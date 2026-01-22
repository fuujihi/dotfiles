local status, nvim_tree = pcall(require, "nvim-tree")
if not status then
	return
end

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

nvim_tree.setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
		side = "left",
		preserve_window_proportions = true,
	},
	renderer = {
		group_empty = true,
		highlight_git = true,
		highlight_opened_files = "all",
		indent_markers = {
			enable = true,
		},
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
		},
	},
	filters = {
		dotfiles = false,
		custom = {
			".git",
			"node_modules",
			".cache",
			".venv",
			"htmlcov",
			"__pycache__",
			".mypy_cache",
			"*.pyc",
		},
	},
	git = {
		enable = true,
		ignore = false,
		show_on_dirs = true,
	},
	actions = {
		open_file = {
			quit_on_open = false,
			resize_window = true,
		},
		change_dir = {
			enable = true,
			global = false,
		},
	},
	tab = {
		sync = {
			open = true,
			close = false,
		},
	},
	on_attach = function(bufnr)
		local api = require("nvim-tree.api")

		local function opts(desc)
			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
		end

		-- default mappings
		api.config.mappings.default_on_attach(bufnr)

		-- custom mappings
		vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
		vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
		vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
		vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
		vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
		vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
		vim.keymap.set("n", "<", api.node.navigate.parent_close, opts("Close Directory"))
		vim.keymap.set("n", ">", api.node.open.edit, opts("Open Directory"))
		vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
		vim.keymap.set("n", "a", api.fs.create, opts("Create"))
		vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
		vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
		vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
		vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
		vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
		vim.keymap.set("n", "q", api.tree.close, opts("Close"))
	end,
})

-- 起動時処理は plugins/init.lua の init 関数に移動済み

-- 新しいタブでもnvim-treeを自動で開く
vim.api.nvim_create_autocmd("TabNewEntered", {
	callback = function()
		-- 少し遅延を入れてツリーを開く（タブ作成の完了を待つ）
		vim.defer_fn(function()
			if require("nvim-tree.view").is_visible() == false then
				require("nvim-tree.api").tree.open()
				-- フォーカスを編集ペインに移動
				vim.defer_fn(function()
					vim.cmd("wincmd l")
				end, 10)
			end
		end, 10)
	end,
})

-- タブを切り替えたときにツリーが閉じている場合は開く
vim.api.nvim_create_autocmd("TabEnter", {
	callback = function()
		vim.defer_fn(function()
			if require("nvim-tree.view").is_visible() == false then
				require("nvim-tree.api").tree.open()
				-- フォーカスを編集ペインに移動
				vim.defer_fn(function()
					vim.cmd("wincmd l")
				end, 10)
			end
		end, 10)
	end,
})

-- ツリーのみになった場合の処理
vim.api.nvim_create_autocmd("BufWinLeave", {
	callback = function(args)
		-- nvim-treeのバッファは無視
		local buf_type = vim.bo[args.buf].filetype
		if buf_type == 'NvimTree' then
			return
		end

		-- 少し遅延してから状態をチェック（ウィンドウ閉じ処理の完了を待つ）
		vim.defer_fn(function()
			-- 現在のタブが有効かチェック
			local current_tab = vim.api.nvim_get_current_tabpage()
			local all_tabs = vim.api.nvim_list_tabpages()

			-- 現在のタブがまだ存在するかチェック
			local tab_exists = false
			for _, tab in ipairs(all_tabs) do
				if tab == current_tab then
					tab_exists = true
					break
				end
			end

			if not tab_exists then
				return  -- タブがもう存在しない場合は何もしない
			end

			-- nvim-treeが開いているかチェック
			if require("nvim-tree.view").is_visible() then
				-- 現在のタブのウィンドウ数をチェック
				local windows = vim.api.nvim_tabpage_list_wins(current_tab)
				local normal_windows = 0

				-- nvim-tree以外のウィンドウをカウント
				for _, win in ipairs(windows) do
					local buf = vim.api.nvim_win_get_buf(win)
					local buf_name = vim.api.nvim_buf_get_name(buf)
					local buf_filetype = vim.bo[buf].filetype
					local buf_buftype = vim.bo[buf].buftype

					-- nvim-tree以外の通常のウィンドウをカウント
					if buf_filetype ~= 'NvimTree' and not string.match(buf_name, 'NvimTree') and buf_buftype == '' then
						normal_windows = normal_windows + 1
					end
				end

				-- 通常のウィンドウが0個の場合（ツリーのみ）
				if normal_windows == 0 then
					local tab_count = #vim.api.nvim_list_tabpages()

					if tab_count > 1 then
						-- 他のタブがある場合は現在のタブを閉じて他のタブに移動
						vim.cmd("tabclose!")
					else
						-- 1つのタブのみの場合は全体を終了
						vim.cmd("quitall!")
					end
				end
			end
		end, 100)
	end,
})