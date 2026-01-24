local keymap = vim.keymap

-- Do not yank with x
keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "-", "<C-x>", { desc = "Decrement number" })

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- New tab
keymap.set("n", "te", ":tabedit<Return>", { silent = true, desc = "New tab" })

-- Close tab
keymap.set("n", "tw", ":tabclose<Return>", { silent = true, desc = "Close tab" })

-- Split window
keymap.set("n", "sw", ":split<Return><C-w>w", { silent = true, desc = "Horizontal split" })
keymap.set("n", "sv", ":vsplit<Return><C-w>w", { silent = true, desc = "Vertical split" })

-- Move window
keymap.set("n", "<Space>", "<C-w>w", { desc = "Next window" })
keymap.set("", "sh", "<C-w>h", { desc = "Move to left window" })
keymap.set("", "sk", "<C-w>k", { desc = "Move to upper window" })
keymap.set("", "sj", "<C-w>j", { desc = "Move to lower window" })
keymap.set("", "sl", "<C-w>l", { desc = "Move to right window" })

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><", { desc = "Decrease width" })
keymap.set("n", "<C-w><right>", "<C-w>>", { desc = "Increase width" })
keymap.set("n", "<C-w><up>", "<C-w>+", { desc = "Increase height" })
keymap.set("n", "<C-w><down>", "<C-w>-", { desc = "Decrease height" })

-- Save
keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, desc = "Save file" })

keymap.set("n", "q", "", { noremap = true })

-- File tree
keymap.set("n", ";t", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file tree" })
