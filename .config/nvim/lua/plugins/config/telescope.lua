local status, telescope = pcall(require, "telescope")
if not status then
	return
end

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		winblend = 20,
		mappings = {
			n = {
				["q"] = actions.close,
			},
		},
	},
	extensions = {},
})

vim.keymap.set("n", ";f", function()
	builtin.find_files({
		no_ignore = true,
		hidden = true,
	})
end)
vim.keymap.set("n", ";g", function()
	telescope.extensions.egrepify.egrepify()
end)
vim.keymap.set("n", "\\\\", function()
	builtin.buffers()
end)
vim.keymap.set("n", ";h", function()
	builtin.help_tags()
end)
-- vim.keymap.set('n', ';;', function()
--   builtin.resume()
-- end)
-- vim.keymap.set('n', ';e', function()
--   builtin.diagnostics()
-- end)
