-- gitsigns
require('gitsigns').setup{
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then return ']h' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map('n', '[h', function()
          if vim.wo.diff then return '[h' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        -- Actions
        map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hd', gs.diffthis)
    end
}
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
