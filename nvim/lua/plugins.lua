vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Misc
  use {
    'junegunn/fzf',
    run = ':call fzf#install()',
    requires = {
      'junegunn/fzf.vim'
    },
  }
  use 'edkolev/tmuxline.vim'

  -- Theme/colours
  use {
    use 'EdenEast/nightfox.nvim',
    use {
      'shadmansaleh/lualine.nvim',
      requires = {
        'kyazdani42/nvim-web-devicons',
        opt = true,
      },
      config = function() require('plugins/lualine') end,
    },
    use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function() require('plugins/nvim-tree') end,
    },
    use 'lukas-reineke/indent-blankline.nvim',
    use {
      'romgrk/barbar.nvim',
      requires = {
        'kyazdani42/nvim-web-devicons',
      },
    },
  }

  -- Git
  use {
    {
      'tpope/vim-fugitive',
      cmd = {
        'Git',
        'Gstatus',
        'Gblame',
        'Gpush',
        'Gpull',
      },
      disable = true,
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
      'neomake/neomake',
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
      }
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
      'Shougo/deoplete.nvim',
      run = ':UpdateRemotePlugins',
    },
    {
      'kristijanhusak/deoplete-phpactor',
      ft = 'php',
    },
    {
      'chrisbra/Colorizer',
      ft = {
        'css',
        'scss',
      },
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
