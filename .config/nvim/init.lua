-- パフォーマンス最適化
vim.loader.enable() -- Lua module caching (Neovim 0.9+)

require("base")
require("highlight")
require("maps")

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
require("lazy").setup(plugins, {
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true, -- reset the package path to improve startup time
		rtp = {
			reset = true, -- reset the runtime path to improve startup time
			---@type string[]
			paths = {}, -- add any custom paths here that you want to includes in the rtp
			---@type string[] list any plugins you want to disable here
			disabled_plugins = {
				"gzip",
				"netrwPlugin", -- nvim-tree使用のため不要
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

local has = function(x)
	return vim.fn.has(x) == 1
end

if has("macunix") then
	vim.opt.clipboard:append({ "unnamedplus" })
end
