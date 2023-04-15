local status, saga = pcall(require, "lspsaga")
if (not status) then return end

saga.setup {
  server_filetype_map = {
    typescript = 'typescript',
    perlnavigator = 'perlnavigator'
  }
}

local opts = { noremap = true, silent = true }
vim.keymap.set('n', 'K',     '<Cmd>Lspsaga hover_doc<CR>', opts)
-- vim.keymap.set('n', '<C-j>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.keymap.set('n', '<C-p>', '<Cmd>Lspsaga peek_definition<CR>', opts)
vim.keymap.set('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>', opts)
-- vim.keymap.set('n', 'gd', '<Cmd>Lspsaga lsp_finder<CR>', opts)
-- vim.keymap.set('n', 'dr', '<Cmd>Lspsaga rename<CR>', opts)
