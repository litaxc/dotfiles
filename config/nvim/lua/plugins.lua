local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable',
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
require 'lazy'.setup({
    { 'shaunsingh/nord.nvim',  config = function() vim.cmd 'colorscheme nord' end },
    { 'windwp/nvim-autopairs', opts = {} },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.opt.termguicolors = true

            require('indent_blankline').setup()
            for _, keymap in pairs({ 'zo', 'zO', 'zc', 'zC', 'za', 'zA', 'zv', 'zx', 'zX', 'zm', 'zM', 'zr', 'zR' }) do
                vim.api.nvim_set_keymap('n', keymap, keymap .. '<CMD>IndentBlanklineRefresh<CR>',
                    { noremap = true, silent = true })
            end
        end
    },
    {
        'ibhagwan/fzf-lua',
        config = function()
            local fzf = require 'fzf-lua'

            vim.keymap.set('n', '<C-\\>', function() fzf.buffers() end, {})
            vim.keymap.set('n', '<C-p>', function() fzf.files() end, {})
            vim.keymap.set('n', '<leader>fg', function() fzf.live_grep_glob() end, {})
            vim.keymap.set('n', '<F1>', function() fzf.help_tags() end, {})
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter',
                build = ':TSUpdate',
                config = function()
                    local config = require 'nvim-treesitter.configs'

                    config.setup {
                        ensure_installed = {
                            'python',
                            'rust',
                            'yaml',
                            'zig',
                        },
                    }
                end
            }
        },
        config = function()
            vim.cmd 'highlight TreesitterContextBottom gui=underline guisp=Grey'
        end
    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
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
                end, { expr = true })

                map('n', '[h', function()
                    if vim.wo.diff then return '[h' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, { expr = true })

                -- Actions
                map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
                map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
                map('n', '<leader>hu', gs.undo_stage_hunk)
                map('n', '<leader>hp', gs.preview_hunk)
                map('n', '<leader>hd', gs.diffthis)
            end
        }
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
        ,
        config = function()
            local lsp = require('lsp-zero').preset({})

            lsp.on_attach(function(_, buffer)
                lsp.default_keymaps({ buffer = buffer })
                local opts = { buffer = buffer }

                vim.keymap.set({ 'n', 'x' }, 'gq', function()
                    vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                end, opts)
                vim.keymap.set({ 'n', 'x' }, 'gr', function()
                    vim.lsp.buf.references({ includeDeclaration = false })
                end, opts)
            end)

            lsp.setup_servers({
                'pyright',
                'zls',
            })

            local lspconfig = require('lspconfig')
            lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
            lspconfig.efm.setup {
                init_options = { documentFormatting = true },
                settings = {
                    languages = {
                        python = {
                            { formatCommand = 'black -S -l 109 -',       formatStdin = true },
                            { formatCommand = 'isort --profile black -', formatStdin = true }
                        }
                    }
                }
            }

            lsp.setup()
        end
    },
    { 'kevinhwang91/nvim-bqf' }
})
