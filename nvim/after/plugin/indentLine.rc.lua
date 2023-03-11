vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
vim.cmd [[highlight IndentBlanklineIndent guifg=#3E4452 gui=nocombine]]

require("indent_blankline").setup {
    show_end_of_line = true,
    char_highlight_list = {
        "IndentBlanklineIndent",
    }
}
