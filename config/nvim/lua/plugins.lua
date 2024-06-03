local autocmd = vim.api.nvim_create_autocmd

autocmd('User', {
    pattern = 'PaqDoneInstall',
    callback = function()
        -- colorscheme
        vim.cmd 'colorscheme rose-pine-dawn'

        -- indent-blankline
        vim.opt.termguicolors = true

        require 'ibl'.setup {
            indent = { char = "│" },
            scope = { enabled = false }
        }
        for _, keymap in pairs({ 'zo', 'zO', 'zc', 'zC', 'za', 'zA', 'zv', 'zx', 'zX', 'zm', 'zM', 'zr', 'zR' }) do
            vim.api.nvim_set_keymap('n', keymap, keymap .. '<CMD>IndentBlanklineRefresh<CR>',
                { noremap = true, silent = true })
        end

        -- auto pairs
        require 'nvim-autopairs'.setup {}

        -- fzf
        local fzf = require 'fzf-lua'

        vim.keymap.set('n', '<C-\\>', function() fzf.buffers() end, {})
        vim.keymap.set('n', '<C-p>', function() fzf.files() end, {})
        vim.keymap.set('n', '<leader>rg', function() fzf.live_grep_glob() end, {})
        vim.keymap.set('n', '<F1>', function() fzf.help_tags() end, {})

        -- gitsigns
        require 'gitsigns'.setup {
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

        -- treesitter
        require 'nvim-treesitter.configs'.setup {
            ensure_installed = {
                'python',
                'vimdoc',
                'yaml',
            },
        }
        vim.cmd 'highlight TreesitterContextBottom guisp=Grey'

        -- lsp
        local lsp = require 'lsp-zero'.preset({})

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

        lsp.setup_servers {
            'pyright',
            'zls',
        }

        local lspconfig = require 'lspconfig'
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
})

local paq = require 'bootstrap'

paq.bootstrap()
