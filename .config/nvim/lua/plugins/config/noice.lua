local status, noice = pcall(require, "noice")
if not status then
	return
end

-- nvim-notifyの設定（通知位置を下に変更）
local notify_status, notify = pcall(require, "notify")
if notify_status then
	notify.setup({
		stages = "fade_in_slide_out",
		render = "compact",
		background_colour = "Normal",
		timeout = 3000,
		top_down = false,  -- 下から表示
		max_height = function()
			return math.floor(vim.o.lines * 0.75)
		end,
		max_width = function()
			return math.floor(vim.o.columns * 0.75)
		end,
	})
	vim.notify = notify
end

noice.setup({
	cmdline = {
		format = {
			search_down = { icon = "" },
			search_up = { icon = "" },
		},
	},
	messages = {
		view = "mini",
	},
	views = {
		popupmenu = {
			relative = "editor",
			position = {
				row = "63%",
				col = "50%",
			},
			size = {
				width = 60,
				height = 10,
			},
			border = {
				style = "rounded",
				padding = { 0, 1 },
			},
			win_options = {
				winhighlight = {
					Normal = "Normal",
					FloatBorder = "DiagnosticInfo",
				},
			},
		},
	},
})
