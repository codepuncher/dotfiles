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
        use({
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
        }),
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
        require('gitsigns').setup()
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
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        -- Snippets
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',
        'rafamadriz/friendly-snippets',
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
      'preservim/nerdcommenter',
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
