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
        end)

        lsp.setup_servers {
            'basedpyright',
            'gopls',
            'lua_ls',
            'ruff',
        }

        local lspconfig = require 'lspconfig'
        lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
        lspconfig.basedpyright.setup {
            settings = {
                basedpyright = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = true,
                        typeCheckingMode = 'standard',
                    }
                }
            }
        }
        lspconfig.ruff.setup {
            init_options = {
                settings = {
                    lineLength = 109,
                }
            }
        }

        lsp.setup()

        local iron = require 'iron.core'
        iron.setup {
            config = {
                repl_definition = {
                    python = {
                        command = { 'ipython', '--no-autoindent' },
                        format = require 'iron.fts.common'.bracketed_paste_python,
                    }
                },
                repl_open_cmd = require 'iron.view'.split.botright(0.2)
            },
            keymaps = {
                send_motion = '<space>rc',
                visual_send = '<space>rc',
                send_paragraph = '<space>rp',
            }
        }
    end
})

local paq = require 'bootstrap'

paq.bootstrap()
