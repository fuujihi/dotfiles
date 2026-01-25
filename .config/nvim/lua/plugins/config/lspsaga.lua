local status, saga = pcall(require, "lspsaga")
if not status then
	return
end

saga.setup({})

-- LSPがアタッチされたバッファでのみキーマップを設定
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local opts = { noremap = true, silent = true, buffer = bufnr }

		vim.keymap.set("n", "K", "<Cmd>Lspsaga peek_definition<CR>", opts)
		vim.keymap.set("n", "<C-p>", "<Cmd>Lspsaga peek_definition<CR>", opts)
		vim.keymap.set("n", "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
		vim.keymap.set("n", "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
		vim.keymap.set("n", "gd", function()
			vim.cmd("vsplit")
			vim.cmd("wincmd w")
			vim.cmd("Lspsaga goto_definition")
		end, opts)
		vim.keymap.set("i", "<C-k>", "<Cmd>Lspsaga signature_help<CR>", opts)
		vim.keymap.set("n", "gr", "<Cmd>Lspsaga lsp_finder<CR>", opts)
	end,
	desc = "Lspsaga: Set keymaps on LspAttach",
})

-- ここから自動ホバー表示の設定
vim.o.updatetime = 1000  -- 1秒カーソルが止まったら CursorHold 発火
vim.api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	callback = function()
		-- LSPがアタッチされていて、hoverをサポートしている場合のみ
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		for _, client in ipairs(clients) do
			if client.supports_method("textDocument/hover") then
				vim.cmd("Lspsaga hover_doc")
				return
			end
		end
	end,
	desc = "Lspsaga: Show hover doc on CursorHold",
})
