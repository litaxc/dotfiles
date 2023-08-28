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

        'shaunsingh/nord.nvim',
        'lukas-reineke/indent-blankline.nvim',

        'windwp/nvim-autopairs',
        { 'ibhagwan/fzf-lua',                branch = 'main' },
        'lewis6991/gitsigns.nvim',
        { 'nvim-treesitter/nvim-treesitter', run = function() vim.cmd ':TSUpdate' end },
        'nvim-treesitter/nvim-treesitter-context',

        'neovim/nvim-lspconfig',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'L3MON4D3/LuaSnip',
        { 'VonHeikemen/lsp-zero.nvim', branch = 'v2.x' },
        'kevinhwang91/nvim-bqf',
    }
end

return {
    bootstrap = bootstrap_plugins
}
