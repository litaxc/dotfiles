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

            vim.lsp.handlers['textDocument/definition'] = function(_, result, _, _)
                if #result == 1 then
                    vim.lsp.util.jump_to_location(result[1])
                else
                    fzf.lsp_definitions()
                end
            end
            vim.keymap.set('n', 'gr', fzf.lsp_references, { buffer = buffer })
        end)

        lsp.setup_servers {
            'gopls',
            -- 'basedpyright',
            -- 'lua_ls',
            -- 'ruff',
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
                    lint = {
                        ignore = { 'F401', 'E741' },
                    }
                }
            }
        }

        lsp.setup()

        -- ipython
        local nbv = require 'notebook-navigator'
        vim.keymap.set("n", "<space>mi", ":MoltenInit python3<CR>", { silent = true })
        vim.keymap.set("n", "<space>md", ":MoltenDeinit<CR>", { silent = true })
        vim.keymap.set("n", "<space>ii", ":MoltenInterrupt<CR>", { silent = true })
        vim.keymap.set("n", "<space>oh", ":MoltenHideOutput<CR>", { silent = true })
        vim.keymap.set("n", "<space>oo", ":noautocmd MoltenEnterOutput<CR>", { silent = true })
        vim.keymap.set('n', '<space>X', nbv.run_cell)
        vim.keymap.set('n', '<space>x', nbv.run_and_move)
        vim.keymap.set('n', ']x', function()
            nbv.move_cell 'd'
            vim.api.nvim_feedkeys('zz', 'n', false)
        end)
        vim.keymap.set('n', '[x', function()
            nbv.move_cell 'u'
            vim.api.nvim_feedkeys('zz', 'n', false)
        end)
        vim.keymap.set("v", "<space>X", ":<C-u>MoltenEvaluateVisual<CR>gv<ESC>", { silent = true })
        vim.api.nvim_set_hl(0, 'MoltenCell', {})
    end
})

local paq = require 'bootstrap'

paq.bootstrap()
