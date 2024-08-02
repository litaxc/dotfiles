local function clone_paq()
    local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
    local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
    if not is_installed then
        vim.fn.system { "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path }
        return true
    end
end

local function bootstrap_paq(packages)
    local first_install = clone_paq()
    vim.cmd.packadd("paq-nvim")
    local paq = require("paq")
    if first_install then
        vim.notify("Installing plugins... If prompted, hit Enter to continue.")
    end

    -- Read and install packages
    paq(packages)
    paq.install()
end

local function bootstrap_plugins()
    bootstrap_paq {
        'savq/paq-nvim',

        { 'rose-pine/neovim', as = 'rose-pine' },
        'lukas-reineke/indent-blankline.nvim',

        'windwp/nvim-autopairs',
        { 'ibhagwan/fzf-lua', branch = 'main' },
        'lewis6991/gitsigns.nvim',
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
        'nvim-treesitter/nvim-treesitter-context',

        'neovim/nvim-lspconfig',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        { 'VonHeikemen/lsp-zero.nvim',       branch = 'v2.x' },

        { 'benlubas/molten-nvim',            build = ':UpdateRemotePlugins' },
        'GCBallesteros/NotebookNavigator.nvim',
    }
end

return {
    bootstrap = bootstrap_plugins
}
