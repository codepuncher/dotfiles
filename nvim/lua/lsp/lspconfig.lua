if not vim.fn.exists('g:lspconfig') then
  return
end

local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  --- Mappings.
  local opts = {
    noremap = true,
    silent = true,
  }

  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  map('n', '<space><space>', '<cmd>Lspsaga signature_help<CR>', opts)
  map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  map('n', '<space>rn', '<cmd>Lspsaga rename<CR>', opts)
  map('n', '<space>ca', '<cmd>Lspsaga code_action<CR>', opts)
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    local format_group = vim.api.nvim_create_augroup('Format', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
      group = format_group,
      callback = function()
        vim.lsp.buf.formatting_seq_sync()
      end,
      buffer = 0,
    })
  end
end

local eslint = require('lsp.efm.eslint')
local shellcheck = require('lsp.efm.shellcheck')
local stylua = require('lsp.efm.stylua')
local prettier = require('lsp.efm.prettier')
local phpcs = require('lsp.efm.phpcs')

nvim_lsp.efm.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  init_options = {
    documentFormatting = true,
  },
  settings = {
    rootMarkers = {
      '.git',
      'package.json',
      '.eslintrc.cjs',
      '.eslintrc',
      '.eslintrc.json',
      '.eslintrc.js',
      '.prettierrc',
      '.prettierrc.js',
      '.prettierrc.json',
      '.prettierrc.yml',
      '.prettierrc.yaml',
      '.prettier.config.js',
      '.prettier.config.cjs',
    },
    languages = {
      bash = {
        shellcheck,
      },
      javascript = {
        eslint,
      },
      lua = {
        stylua,
      },
      typescript = {
        eslint,
        prettier,
      },
      php = {
        phpcs,
      },
      vue = {
        prettier,
      },
    },
  },
})

nvim_lsp.intelephense.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
  end,
  init_options = {
    documentFormatting = false,
  },
  filetypes = {
    'php',
    'blade',
  },
  settings = {
    format = {
      enable = false,
    },
    intelephense = {
      format = {
        enable = false,
      },
    },
  },
})

nvim_lsp.tailwindcss.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    'html',
    'css',
  },
})

nvim_lsp.tsserver.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
  end,
  filetypes = {
    'javascript',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
})

nvim_lsp.bashls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    'sh',
    'bash',
  },
})

nvim_lsp.svelte.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    'svelte',
  },
})

nvim_lsp.ltex.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    ltex = {
      language = 'en',
    },
  },
})

local stylelint_filetypes = {
  'sass',
  'scss',
  'postcss',
}
nvim_lsp.stylelint_lsp.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = stylelint_filetypes,
  settings = {
    stylelintplus = {
      autoFixOnSave = true,
      autoFixOnFormat = true,
      filetypes = stylelint_filetypes,
    },
  },
})

nvim_lsp.vuels.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

nvim_lsp.jsonls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {
    'vscode-json-language-server',
    '--stdio',
  },
  settings = {
    json = {
      -- Schemas https://www.schemastore.org
      schemas = {
        { fileMatch = { 'package.json' }, url = 'https://json.schemastore.org/package.json' },
        { fileMatch = { 'tsconfig*.json' }, url = 'https://json.schemastore.org/tsconfig.json' },
        {
          fileMatch = { '.prettierrc', '.prettierrc.json', 'prettier.config.json' },
          url = 'https://json.schemastore.org/prettierrc.json',
        },
        { fileMatch = { '.eslintrc', '.eslintrc.json' }, url = 'https://json.schemastore.org/eslintrc.json' },
        {
          fileMatch = { '.babelrc', '.babelrc.json', 'babel.config.json' },
          url = 'https://json.schemastore.org/babelrc.json',
        },
        {
          fileMatch = { '.stylelintrc', '.stylelintrc.json', 'stylelint.config.json' },
          url = 'http://json.schemastore.org/stylelintrc.json',
        },
        {
          fileMatch = { 'composer.json' },
          url = 'https://raw.githubusercontent.com/composer/composer/master/res/composer-schema.json',
        },
      },
    },
  },
})

nvim_lsp.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

nvim_lsp.gopls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require('lsp.lua-lsp')
