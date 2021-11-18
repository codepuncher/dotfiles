if not vim.fn.exists('g:lspconfig') then
  return
end

local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
  local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  --- Mappings.
  local opts = { noremap = true, silent = true }

  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  map('n', '<space>rn', '<cmd>Lspsaga rename<CR>', opts)
  map('n', '<space>ca', '<cmd>Lspsaga code_action<CR>', opts)
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  map('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  map('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end
end

local eslint = require('lsp.efm.eslint')
local prettier = require('lsp.efm.prettier')

nvim_lsp.phpactor.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    'php',
  },
  root_dir = nvim_lsp.util.root_pattern('composer.json', '.git', 'functions.php'),
}

nvim_lsp.tailwindcss.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    'html',
    'css',
    'sass',
    'scss',
    -- 'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
  }
}

nvim_lsp.tsserver.setup {
  capabilities = capabilities,
  on_attach = function (client, bufnr)
    client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
  end,
  filetypes = {
    'javascript',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
}

nvim_lsp.bashls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    'sh',
    'bash',
  },
}

nvim_lsp.svelte.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    'svelte',
  },
}

nvim_lsp.ltex.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    ltex = {
      language = 'en',
    },
  },
}

nvim_lsp.efm.setup {
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
      javascript = {
        eslint,
        prettier,
      },
      typescript = {
        eslint,
        prettier,
      },
      scss = {
        prettier,
      },
    },
  },
}

require'lsp.lua-lsp'
