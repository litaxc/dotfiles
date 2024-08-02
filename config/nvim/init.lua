vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'nvc'
vim.o.list = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.cursorline = true
vim.o.scrolloff = 100

vim.o.clipboard = 'unnamed'

vim.o.foldmethod = 'syntax'
vim.o.foldenable = false

vim.o.autoread = true


local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local editor_basics = augroup('editor_basics', {})
autocmd('CursorHold', {
    desc = "reload buffer if underlaying file changed",
    group = editor_basics,
    pattern = '*',
    callback = function()
        if vim.fn.getcmdwintype() == '' then
            vim.cmd 'checktime'
        end
    end
})
autocmd('BufReadPost', {
    desc = "jump to the last cursor position on file open",
    group = editor_basics,
    pattern = '*',
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.fn.setpos(".", vim.fn.getpos("'\""))
        end
    end
})


local filetypedetect = augroup('filetypedetect', {})
autocmd('FileType', {
    group = filetypedetect,
    pattern = { 'json', 'yaml', 'typescript', 'javascript' },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.foldmethod = 'indent'
    end
})
autocmd('FileType', {
    group = filetypedetect,
    pattern = 'python',
    callback = function()
        vim.opt_local.foldmethod = 'indent'
    end
})
autocmd('FileType', {
    group = filetypedetect,
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
