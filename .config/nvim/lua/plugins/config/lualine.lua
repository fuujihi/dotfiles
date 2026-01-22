local status, lualine = pcall(require, "lualine")
if not status then
	return
end

lualine.setup({
	options = {
		icons_enabled = true,
		-- theme = 'solarized_dark',
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		disabled_filetypes = {},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			{
				"filename",
				file_status = true, -- displays file status (readonly status, modified status)
				path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
			},
		},
		lualine_x = {
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
			},
			"encoding",
			"filetype",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				"filename",
				file_status = true, -- displays file status (readonly status, modified status)
				path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
			},
		},
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = {
			{
				function()
					local tabs = {}
					local current_tab = vim.fn.tabpagenr()

					for tab = 1, vim.fn.tabpagenr('$') do
						local winnr = vim.fn.tabpagewinnr(tab)
						local bufnr = vim.fn.tabpagebuflist(tab)[winnr]
						local filename = vim.fn.bufname(bufnr)

						-- ファイル名とアイコンを取得
						local name
						local icon = ""
						local modified = ""

						if filename == "" then
							name = "[No Name]"
							icon = " "
						else
							name = vim.fn.fnamemodify(filename, ":t")
							-- nvim-web-deviconsからアイコンを取得
							local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
							if devicons_ok then
								local file_icon = devicons.get_icon(name, vim.fn.fnamemodify(filename, ":e"), { default = true })
								if file_icon then
									icon = file_icon .. " "
								else
									icon = " "
								end
							else
								icon = " "
							end

							-- ファイルが変更されている場合は●を表示
							if vim.fn.getbufvar(bufnr, "&modified") == 1 then
								modified = " ●"
							end
						end

						-- タブの表示文字列を構築
						local tab_label = string.format("%d:%s%s%s", tab, icon, name, modified)

						-- 現在のタブはハイライト（太字）にする
						if tab == current_tab then
							tab_label = "%#TabLineSel#" .. " " .. tab_label .. " " .. "%*"
						else
							tab_label = "%#TabLine#" .. " " .. tab_label .. " " .. "%*"
						end

						table.insert(tabs, tab_label)
					end

					return table.concat(tabs, "")
				end,
				color = function()
					return { bg = "#3e4451", fg = "#abb2bf" }
				end,
			},
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	extensions = { "fugitive" },
})

-- bufferlineの代替として、同じキーバインディングを設定
vim.keymap.set("n", "<Tab>", function()
	vim.cmd("tabnext")
end, { desc = "次のタブに移動" })

vim.keymap.set("n", "<S-Tab>", function()
	vim.cmd("tabprevious")
end, { desc = "前のタブに移動" })
