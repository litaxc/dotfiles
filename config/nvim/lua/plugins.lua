local autocmd = vim.api.nvim_create_autocmd

autocmd('User', {
    pattern = 'PaqDoneInstall',
    callback = function()
        -- colorscheme
        vim.cmd 'colorscheme rose-pine-main'

        -- indent-blankline
        vim.opt.termguicolors = true

        require 'ibl'.setup {
            indent = { char = "│" },
            scope = { enabled = false }
        }

        -- auto pairs
        require 'nvim-autopairs'.setup {}

        -- fzf
        local fzf = require 'fzf-lua'
        fzf.setup { lsp = { symbols = { symbol_style = 3 } } }

        vim.keymap.set('n', '<C-\\>', function() fzf.buffers() end, {})
        vim.keymap.set('n', '<C-p>', function() fzf.files() end, {})
        vim.keymap.set('n', '<leader>rg', function() fzf.live_grep_glob() end, {})
        vim.keymap.set('n', '<F1>', function() fzf.help_tags() end, {})
        vim.keymap.set('n', '<leader>fd', function() fzf.lsp_document_diagnostics() end, {})
        vim.keymap.set('n', '<leader>fs', function() fzf.lsp_document_symbols() end, {})

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
            sync_install = false,
            auto_install = true,
            ignore_install = {},
            modules = {},
        }

        -- lsp
        local lsp = require 'lsp-zero'.preset({})

        lsp.on_attach(function(_, buffer)
            lsp.default_keymaps { buffer = buffer }

            vim.lsp.handlers['textDocument/definition'] = function(_, result, _, _)
                if #result == 1 then
                    vim.lsp.util.jump_to_location(result[1])
                else
                    fzf.lsp_definitions()
                end
            end
            vim.keymap.set('n', 'gr', fzf.lsp_references, { buffer = buffer })
        end)

        local lspconfig = require 'lspconfig'

        ---@param pkg_paths string[]
        local add_pkg_to_lua_path = function(pkg_paths)
            local uv = vim.uv
            local pkg_base_path = vim.fn.stdpath("data") .. "/site/pack/paqs/start"
            local handle = uv.fs_scandir(pkg_base_path)
            while handle do
                local name, t = uv.fs_scandir_next(handle)
                if t == 'directory' then
                    local dir = pkg_base_path .. '/' .. name .. '/lua'
                    table.insert(pkg_paths, dir)
                elseif not name then
                    break
                end
            end
            return pkg_paths
        end
        local lua_config = lsp.nvim_lua_ls()
        lua_config.settings.Lua.workspace.library = add_pkg_to_lua_path(lua_config.settings.Lua.workspace.library)
        lspconfig.lua_ls.setup(lua_config)

        lspconfig.basedpyright.setup {
            settings = {
                basedpyright = {
                    disableOrganizeImports = true,
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = true,
                        typeCheckingMode = 'standard',
                    }
                }
            }
        }

        local sort_python_imports = function()
            local buffer = vim.api.nvim_get_current_buf()
            local params = {
                command = "ruff.applyOrganizeImports",
                arguments = { { uri = vim.uri_from_bufnr(buffer), version = 0 } },
            }
            local clients = vim.lsp.get_clients {
                bufnr = buffer,
                name = 'ruff',
            }
            for _, client in ipairs(clients) do
                client.request('workspace/executeCommand', params)
            end
        end
        lspconfig.ruff.setup {
            init_options = {
                settings = {
                    lineLength = 109,
                    lint = {
                        extendSelect = { 'I' },
                        ignore = { 'F401', 'E741' },
                    }
                }
            },
            on_attach = function(client, _)
                vim.lsp.handlers['textDocument/formatting'] = function(_, _, _, _)
                    vim.lsp.buf.format { bufnr = vim.api.nvim_get_current_buf(), id = client.id }
                    -- sort python imports
                    client.request('workspace/executeCommand',
                        { command = "ruff.applyOrganizeImports", arguments = { { uri = vim.uri_from_bufnr(0), version = 0 } } })
                end
                client.server_capabilities.hoverProvider = false
            end,
            commands = {
                RuffOrganizeImports = {
                    sort_python_imports,
                    description = "Ruff: Format imports",
                },
            }
        }

        lsp.setup()
    end
})

local paq = require 'bootstrap'

paq.bootstrap()
