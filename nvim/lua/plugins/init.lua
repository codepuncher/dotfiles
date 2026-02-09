local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '

require('lazy').setup({
  -- Misc
  {
    'famiu/bufdelete.nvim',
    {
      'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install',
        },
        'nvim-telescope/telescope-github.nvim',
        'nvim-telescope/telescope-node-modules.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
      },
      config = function()
        require('plugins.configs.telescope')
      end,
    },
    'folke/which-key.nvim',
  },

  -- UI
  {
    {
      'folke/tokyonight.nvim',
      lazy = false,
      priority = 1000,
      opts = {},
      config = function()
        require('tokyonight').setup({
          style = 'storm',
          transparent = true,
          styles = {
            sidebars = 'transparent',
            floats = 'transparent',
          },
        })
        vim.cmd([[colorscheme tokyonight]])
      end,
    },
    {
      'nvim-lualine/lualine.nvim',
      config = function()
        require('plugins.configs.lualine')
      end,
      dependencies = {
        'nvim-tree/nvim-web-devicons',
        'linrongbin16/lsp-progress.nvim',
      },
    },
    {
      'linrongbin16/lsp-progress.nvim',
      dependencies = {
        'nvim-tree/nvim-web-devicons',
      },
      config = function()
        require('lsp-progress').setup({})
      end,
    },
    {
      'akinsho/bufferline.nvim',
      version = '*',
      config = function()
        require('plugins.configs.bufferline')
      end,
      dependencies = {
        'nvim-tree/nvim-web-devicons',
      },
    },
    {
      'nvim-tree/nvim-tree.lua',
      version = '*',
      lazy = false,
      dependencies = {
        'nvim-tree/nvim-web-devicons',
      },
      config = function()
        require('plugins.configs.nvim-tree')
      end,
    },
    {
      'lukas-reineke/indent-blankline.nvim',
      main = 'ibl',
      ---@module 'ibl'
      ---@type ibl.config
      opts = {},
      config = function()
        require('plugins.configs.indent-blankline')
      end,
    },
    {
      'rcarriga/nvim-notify',
      config = function()
        local notify = require('notify')
        vim.notify = notify
        notify.setup({
          merge_duplicates = false,
          background_colour = '#000000',
        })
      end,
    },
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('plugins.configs.treesitter')
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-locals',
      'JoosepAlviste/nvim-ts-context-commentstring',
      {
        'windwp/nvim-ts-autotag',
        config = function()
          require('plugins.configs.nvim-ts-autotag')
        end,
      },
      'andymass/vim-matchup',
    },
  },

  -- Language Server Protocol
  {
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
    },
    {
      'nvimtools/none-ls.nvim',
      dependencies = {
        'nvimtools/none-ls-extras.nvim',
        'nvim-lua/plenary.nvim',
      },
    },
    {
      'nvimdev/lspsaga.nvim',
      config = function()
        require('plugins.configs.lspsaga')
      end,
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
      },
      event = 'LspAttach',
    },
    {
      'ray-x/lsp_signature.nvim',
      config = function()
        require('plugins.configs.lsp_signature')
      end,
    },
    {
      'folke/trouble.nvim',
      dependencies = {
        'nvim-tree/nvim-web-devicons',
      },
      cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle', 'TroubleRefresh' },
      config = function()
        require('plugins.configs.trouble')
      end,
    },
  },

  -- Debug Adapter Protocol
  -- {
  --   {
  --     'mfussenegger/nvim-dap',
  --     config = function()
  --       require('plugins.configs.dap')
  --     end,
  --   },
  --   'rcarriga/nvim-dap-ui',
  --   'rcarriga/cmp-dap',
  --   'theHamsta/nvim-dap-virtual-text',
  --   'nvim-telescope/telescope-dap.nvim',
  --   'leoluz/nvim-dap-go',
  -- },

  -- Git
  {
    {
      'tpope/vim-fugitive',
      cmd = {
        'Git',
        'Git add',
        'Git commit',
        'Git push',
        'Git status',
        'Gvdiffsplit',
      },
    },
    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('plugins.configs.gitsigns')
      end,
    },
  },

  -- Dev
  {
    {
      'hrsh7th/nvim-cmp',
      config = function()
        require('plugins.configs.cmp')
      end,
      dependencies = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-emoji',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'saadparwaiz1/cmp_luasnip',
        'petertriho/cmp-git',
        'onsails/lspkind-nvim',
        {
          'zbirenbaum/copilot-cmp',
          dependencies = {
            {
              'zbirenbaum/copilot.lua',
              dependencies = {
                'copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
              },
              config = function()
                require('copilot').setup({
                  suggestion = { enabled = false },
                  panel = { enabled = false },
                })
              end,
            },
          },
          config = function()
            require('copilot_cmp').setup({
              method = 'getCompletionsCycling',
              format = {
                before = function(_, vim_item)
                  vim_item.kind = require('lspkind').presets.default[vim_item.kind] .. ' Copilot'
                  return vim_item
                end,
              },
            })
          end,
        },
        {
          'L3MON4D3/LuaSnip',
          dependencies = {
            'rafamadriz/friendly-snippets',
          },
          build = 'make install_jsregexp',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
      opts = function(_, opts)
        opts.sources = opts.sources or {}
        table.insert(opts.sources, {
          name = 'lazydev',
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        })
      end,
    },
    {
      'windwp/nvim-autopairs',
      config = function()
        require('plugins.configs.autopairs')
      end,
    },
    {
      'tpope/vim-surround',
    },
    {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    },
    {
      'gpanders/editorconfig.nvim',
    },
    {
      'brenoprata10/nvim-highlight-colors',
      config = function()
        local plugin = require('nvim-highlight-colors')
        plugin.setup({
          render = 'background',
          enable_tailwind = true,
        })
        plugin.toggle()
      end,
      event = 'BufEnter',
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
    {
      'iamcco/markdown-preview.nvim',
      build = 'cd app && yarn',
      config = function()
        vim.g.mkdp_filetypes = { 'markdown' }
      end,
      ft = {
        'markdown',
      },
    },
  },
})
