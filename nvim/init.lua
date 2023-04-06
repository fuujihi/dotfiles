require('plugins')
require('base')
require('highlight')
require('maps')
-- require'lspconfig'.perlnavigator.setup{}
-- require'lspconfig'.gopls.setup{}


local has = function(x)
  return vim.fn.has(x) == 1
end

if has "macunix" then
  vim.opt.clipboard:append { 'unnamedplus' }
end
