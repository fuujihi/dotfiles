require('base')
require('highlight')
require('maps')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

plugins = require("plugins")
require("lazy").setup(plugins)

local has = function(x)
    return vim.fn.has(x) == 1
end

if has "macunix" then
    vim.opt.clipboard:append { 'unnamedplus' }
end

