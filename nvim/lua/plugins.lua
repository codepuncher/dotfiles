vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Misc
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function () require('custom.telescope') end,
  }
  use {
    'edkolev/tmuxline.vim',
  }
  use {
    'ceigh/AutoSave.nvim',
    branch = 'execution_message-fn',
    config = function () require('custom.autosave') end,
  }

  -- Theme/colours
  use {
    use {
      'folke/tokyonight.nvim',
    },
    use {
      'nvim-lualine/lualine.nvim',
      requires = {
        'kyazdani42/nvim-web-devicons',
      },
      config = function() require('custom.lualine') end,
    },
    use 'famiu/bufdelete.nvim',
    use {
      'akinsho/bufferline.nvim',
      config = function () require('custom.bufferline') end,
    },
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons',
      },
      config = function () require('custom.nvim-tree') end,
    },
    use 'lukas-reineke/indent-blankline.nvim',
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function() require('custom.treesitter') end,
    },
    use 'nvim-treesitter/nvim-treesitter-refactor',
    use 'nvim-treesitter/nvim-treesitter-textobjects',
  }

  -- Git
  use {
    {
      'tpope/vim-fugitive',
      cmd = {
        'Git',
      },
    },
    {
      'tpope/vim-rhubarb',
    },
    {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
      },
      config = function() require('gitsigns').setup() end,
    },
  }

  -- Dev
  use {
    {
      'neovim/nvim-lspconfig',
      config = function() require('lsp.lspconfig') end,
    },
    {
      'rinx/lspsaga.nvim', -- this is a fork to fix hover_doc not working whilst repo maintainer is OOA.
      config = function() require('lsp.lspsaga') end,
    },
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
      },
      config = function() require('custom.cmp') end,
    },
    {
      'windwp/nvim-autopairs',
      config = function() require('custom.autopairs') end,
    },
    {
      'windwp/nvim-ts-autotag',
      config = function() require('custom.autotag') end,
    },
    {
      'tpope/vim-surround',
    },
    {
    'folke/trouble.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      -- TODO: fix the config not loading without :source xxx
      config = function() require('trouble').setup{
        auto_open = true,
        auto_close = true,
        auto_preview = true,
      } end,
    },
    {
      'preservim/nerdcommenter',
    },
    {
      'editorconfig/editorconfig-vim',
      ft = {
        'js',
        'ts',
        'css',
        'scss',
        'php',
        'blade',
      },
    },
    {
      'StanAngeloff/php.vim',
      ft = 'php',
    },
    {
      'phpactor/phpactor',
      ft = 'php',
      run = 'composer install --no-dev -o',
    },
    {
      'RRethy/vim-hexokinase',
      run = 'make hexokinase',
    },
    {
      'jwalton512/vim-blade',
      ft = 'blade',
    },
    {
      'preservim/tagbar',
      ft = 'php',
    },
    {
      'mattn/emmet-vim',
      ft = {
        'html',
        'php',
        'blade',
      },
    },
  }
end)
