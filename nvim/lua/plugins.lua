vim.api.nvim_command('packadd packer.nvim')

return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  -- Misc
  use({
    -- Dependency for many plugins.
    'nvim-lua/plenary.nvim',

    'famiu/bufdelete.nvim',
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
        },
        'nvim-telescope/telescope-github.nvim',
      },
      config = function()
        require('custom.telescope')
      end,
    },
  })

  -- Theme/colours
  use({
    {
      'folke/tokyonight.nvim',
      requires = { { 'kyazdani42/nvim-web-devicons', opt = true } },
    },
    {
      'nvim-lualine/lualine.nvim',
      requires = { { 'kyazdani42/nvim-web-devicons', opt = true } },
      config = function()
        require('custom.lualine')
      end,
    },
    {
      'akinsho/bufferline.nvim',
      tag = '*',
      config = function()
        require('custom.bufferline')
      end,
    },
    {
      'kyazdani42/nvim-tree.lua',
      opt = true,
      event = {
        'BufEnter',
      },
      config = function()
        require('custom.nvim-tree')
      end,
    },
    'lukas-reineke/indent-blankline.nvim',
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      requires = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter-refactor',
      },
      config = function()
        require('custom.treesitter')
      end,
    },
    {
      'simrat39/symbols-outline.nvim',
      cmd = 'SymbolsOutline',
      config = function()
        require('custom.symbols-outline')
      end,
    },
  })

  -- Git
  use({
    {
      'tpope/vim-fugitive',
      cmd = {
        'Git',
        'Git add',
        'Git commit',
        'Git push',
        'Git status',
      },
    },
    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('custom.gitsigns')
      end,
    },
  })

  -- Dev
  use({
    {
      'neovim/nvim-lspconfig',
      after = 'nvim-cmp',
      config = function()
        require('lsp.lspconfig')
      end,
    },
    {
      -- this fork is for whilst repo maintainer is OOA.
      'tami5/lspsaga.nvim',
      config = function()
        require('lsp.lspsaga')
      end,
    },
    {
      'hrsh7th/nvim-cmp',
      config = function()
        require('custom.cmp')
      end,
      requires = {
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp', before = 'nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        { 'petertriho/cmp-git', after = 'nvim-cmp' },
        { 'onsails/lspkind-nvim', module = 'lspkind' },
        {
          'L3MON4D3/LuaSnip',
          -- module = 'luasnip',
          bufread = false,
          requires = {
            'rafamadriz/friendly-snippets',
          },
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    {
      'windwp/nvim-autopairs',
      config = function()
        require('custom.autopairs')
      end,
    },
    {
      'windwp/nvim-ts-autotag',
      config = function()
        require('custom.autotag')
      end,
    },
    {
      'tpope/vim-surround',
    },
    {
      'folke/trouble.nvim',
      requires = { { 'kyazdani42/nvim-web-devicons', opt = true } },
      cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle', 'TroubleRefresh' },
      config = function()
        require('custom.trouble')
      end,
    },
    {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    },
    {
      'editorconfig/editorconfig-vim',
    },
    {
      'RRethy/vim-hexokinase',
      event = 'BufEnter',
      run = 'make hexokinase',
      ft = {
        'php',
        'html',
        'js',
        'css',
        'scss',
      },
    },
    {
      'jwalton512/vim-blade',
      ft = 'blade',
    },
    {
      'mattn/emmet-vim',
      ft = {
        'html',
        'php',
        'blade',
      },
    },
  })
end)
