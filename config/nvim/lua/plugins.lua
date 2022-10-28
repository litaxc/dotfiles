-- gitsigns
require('gitsigns').setup()

-- indent_blankline
vim.opt.termguicolors = true
vim.opt.list = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#eeeeee gui=nocombine]]

require("indent_blankline").setup {
    char_highlight_list = {
        "IndentBlanklineIndent1",
    }
}

-- nvim-colorizer
require('colorizer').setup()
