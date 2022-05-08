vim.cmd([[packadd packer.nvim]])

return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  -- Misc
  use({
    -- Dependency for many plugins.
    'nvim-lua/plenary.nvim',
    -- Dependency for many plugins.
    'kyazdani42/nvim-web-devicons',
    'famiu/bufdelete.nvim',
    {
      'nvim-telescope/telescope.nvim',
      requires = {
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
    },
    {
      'edkolev/tmuxline.vim',
    },
    {
      'nvim-lualine/lualine.nvim',
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
      config = function()
        require('custom.nvim-tree')
      end,
    },
    'lukas-reineke/indent-blankline.nvim',
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('custom.treesitter')
      end,
    },
    'nvim-treesitter/nvim-treesitter-refactor',
    'nvim-treesitter/nvim-treesitter-textobjects',
    {
      'simrat39/symbols-outline.nvim',
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
      'L3MON4D3/LuaSnip',
      requires = {
        'rafamadriz/friendly-snippets',
      },
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-emoji',
        'saadparwaiz1/cmp_luasnip',
      },
      config = function()
        require('custom.cmp')
      end,
    },
    {
      'onsails/lspkind-nvim',
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
      requires = 'kyazdani42/nvim-web-devicons',
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
