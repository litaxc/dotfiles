vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'nvc'
vim.o.list = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.cursorline = true

vim.env.LANG = 'en_US.UTF-8' -- fix clipboard issue
vim.o.clipboard = 'unnamed'

vim.o.foldmethod = 'syntax'
vim.o.foldenable = false

vim.o.autoread = true

vim.cmd 'highlight Folded ctermbg=None ctermfg=102'
vim.cmd 'highlight DiffText ctermbg=1'


local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local editor_basics = augroup('editor_basics', {})
autocmd('CursorHold', {
    group = editor_basics,
    pattern = '*',
    callback = function()
        if vim.fn.getcmdwintype() == '' then
            vim.cmd 'checktime'
        end
    end
})
autocmd('BufReadPost', {
    group = editor_basics,
    pattern = '*',
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.cmd 'normal! g`"'
        end
    end
})


local filetypedetect = augroup('filetypedetect', {})
autocmd('FileType', {
    pattern = { 'json', 'yaml', 'typescript', 'javascript' },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.foldmethod = 'indent'
    end
})
autocmd('FileType', {
    pattern = 'python',
    callback = function()
        vim.opt_local.foldmethod = 'indent'
    end
})
autocmd('FileType', {
    pattern = 'go',
    callback = function()
        vim.opt_local.tabstop = 8
        vim.opt_local.shiftwidth = 8
        vim.opt_local.expandtab = false
    end
})

if vim.fn.exists('g:vscode') == 0 then
    require 'plugins'
end
