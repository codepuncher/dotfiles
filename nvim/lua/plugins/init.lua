local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
end

vim.api.nvim_command('packadd packer.nvim')

local _packer, packer = pcall(require, 'packer')
if not _packer then
  return
end

packer.init({
  auto_clean = true,
  display = {
    open_fn = function ()
      return require('packer.util').float({border = 'single'})
    end,
    prompt_border = 'single',
  },
  compile_on_sync = true,
})

return packer.startup(function(use)
  use('wbthomason/packer.nvim')

  -- Performance
  use('lewis6991/impatient.nvim')

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
        require('plugins.configs.telescope')
      end,
    },
  })

  -- UI
  use({
    'kyazdani42/nvim-web-devicons',
    {
      'folke/tokyonight.nvim',
      requires = { { 'kyazdani42/nvim-web-devicons', opt = true } },
    },
    {
      'nvim-lualine/lualine.nvim',
      requires = { { 'kyazdani42/nvim-web-devicons', opt = true } },
      config = function()
        require('plugins.configs.lualine')
      end,
    },
    {
      'akinsho/bufferline.nvim',
      after = 'nvim-web-devicons',
      tag = '*',
      config = function()
        require('plugins.configs.bufferline')
      end,
    },
    {
      'kyazdani42/nvim-tree.lua',
      opt = true,
      event = {
        'BufEnter',
      },
      config = function()
        require('plugins.configs.nvim-tree')
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
        require('plugins.configs.treesitter')
      end,
    },
    {
      'simrat39/symbols-outline.nvim',
      cmd = 'SymbolsOutline',
      config = function()
        require('plugins.configs.symbols-outline')
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
        require('plugins.configs.gitsigns')
      end,
    },
  })

  -- Dev
  use({
    {
      'neovim/nvim-lspconfig',
      requires = {
        {
          'folke/lua-dev.nvim',
          'jose-elias-alvarez/typescript.nvim',
          'ray-x/lsp_signature.nvim',
        },
      },
    },
    {
      -- this fork is for whilst repo maintainer is OOA.
      'tami5/lspsaga.nvim',
    },
    {
      'hrsh7th/nvim-cmp',
      config = function()
        require('plugins.configs.cmp')
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
        require('plugins.configs.autopairs')
      end,
    },
    {
      'windwp/nvim-ts-autotag',
      config = function()
        require('plugins.configs.autotag')
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
        require('plugins.configs.trouble')
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

  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
