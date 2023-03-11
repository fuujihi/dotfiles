require('plugins')
require('base')
require('highlight')
require('maps')
require('onedark').setup {}
require('onedark').load()
require'lspconfig'.perlnavigator.setup{}
require'lspconfig'.gopls.setup{}
require('mason').setup()
require('mason-lspconfig').setup()

local has = function(x)
  return vim.fn.has(x) == 1
end

if has "macunix" then
  vim.opt.clipboard:append { 'unnamedplus' }
end
