-- treesitter設定 - 安全版

-- プラグインの準備ができるまで待機
local function setup_treesitter()
	-- まずtreesitterプラグインの存在を確認
	local treesitter_ok = pcall(require, "nvim-treesitter")
	if not treesitter_ok then
		vim.notify("nvim-treesitterプラグインが見つかりません", vim.log.levels.INFO)
		return false
	end

	-- 次にconfigsモジュールを確認
	local configs_ok, configs = pcall(require, "nvim-treesitter.configs")
	if not configs_ok then
		vim.notify("nvim-treesitter.configsが見つかりません", vim.log.levels.INFO)
		return false
	end

	return configs
end

-- 初回試行
local configs = setup_treesitter()
if not configs then
	-- 失敗した場合、少し待って再試行
	vim.defer_fn(function()
		configs = setup_treesitter()
		if not configs then
			vim.notify("treesitterの初期化をスキップしました", vim.log.levels.INFO)
			return
		end
		configure_treesitter(configs)
	end, 500)
	return
end

-- treesitter設定関数
local function configure_treesitter(configs)
	-- 成功した場合のみ設定を実行
	configs.setup({
		-- 言語パーサーのインストール
		ensure_installed = {
			"lua",
			"python",
			"javascript",
			"typescript",
			"json",
			"markdown",
			"bash",
			"html",
			"css",
		},

		-- 安全なオプション
		sync_install = false,
		auto_install = true,
		ignore_install = {},

		-- ハイライト設定
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},

		-- インデント設定
		indent = {
			enable = true,
		},

		-- 増分選択（基本のみ）
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
	})

end

-- 初回設定実行（成功した場合）
if configs then
	configure_treesitter(configs)
end