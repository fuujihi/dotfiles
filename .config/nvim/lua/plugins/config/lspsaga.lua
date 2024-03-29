local status, saga = pcall(require, "lspsaga")
if not status then
	return
end

saga.setup({})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
vim.keymap.set("n", "]", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
vim.keymap.set("n", "[", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
vim.keymap.set("n", "<C-p>", "<Cmd>Lspsaga peek_definition<CR>", opts)
vim.keymap.set("i", "<C-k>", "<Cmd>Lspsaga signature_help<CR>", opts)
vim.keymap.set("n", "gr", "<Cmd>Lspsaga lsp_finder<CR>", opts)
-- vim.keymap.set('n', 'dr', '<Cmd>Lspsaga rename<CR>', opts)
