if not vim.fn.exists('g:lspconfig') then
  return
end

local nvim_lsp = require('lspconfig')

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

nvim_lsp.phpactor.setup {
  on_attach = on_attach,
  filetypes = {
    'php',
  },
}

nvim_lsp.tailwindcss.setup {
  on_attach = on_attach,
  filetypes = {
    'blade',
    'html',
    'php',
    'css',
    'sass',
    'scss',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
  }
}

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = {
    'javascript',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
}

nvim_lsp.bashls.setup {
  on_attach = on_attach,
  filetypes = {
    'sh',
    'bash',
  },
}

nvim_lsp.svelte.setup {
  on_attach = on_attach,
  filetypes = {
    'svelte',
  },
}

nvim_lsp.ltex.setup {
  on_attach = on_attach,
  settings = {
    ltex = {
      language = 'en',
    },
  },
}

nvim_lsp.diagnosticls.setup {
  on_attach = on_attach,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'css',
    'scss',
    'json',
    'markdown',
    'pandoc',
  },
  init_options = {
    filetypes = {
      javascript = 'eslint',
      typescript = 'eslint',
      javascriptreact = 'eslint',
      typescriptreact = 'eslint',
    },
    linters = {
      eslint = {
        sourceName = 'eslint_d',
        rootPatterns = {
          'package.json',
          '.eslintrc.js',
          '.git',
        },
        command = 'eslint_d',
        debounce = 100,
        args = {
          '--stdin',
          '--stdin-filename',
          '%filepath',
          '--format',
          'json',
        },
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity',
        },
        securities = {
          [2] = 'error',
          [1] = 'warning',
        },
      },
    },
    formatters = {
      eslint_d = {
        command = 'eslint_d',
        args = {
          '--stdin',
          '--stdin-filename',
          '%filename',
          '--fix-to-stdout',
        },
        rootPatterns = {
          'package.json',
          '.eslintrc.js',
          '.git',
        },
      },
      prettier = {
        command = 'prettier',
        args = {
          '--stdin-filepath',
          '%filename',
        },
      },
    },
    formatFiletypes = {
      css = 'prettier',
      javascript = 'eslint_d',
      javascriptreact = 'eslint_d',
      scss = 'prettier',
      less = 'prettier',
      typescript = 'eslint_d',
      typescriptreact = 'eslint_d',
      json = 'prettier',
      markdown = 'prettier',
    },
  },
}

require'lsp.lua-lsp'
