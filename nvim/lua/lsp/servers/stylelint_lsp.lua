local _M = {}

_M.setup = function(on_attach, capabilities)
  local filetypes = {
    'sass',
    'scss',
    'postcss',
  }

  require('lspconfig').stylelint_lsp.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    filetypes = filetypes,
    settings = {
      stylelintplus = {
        autoFixOnSave = true,
        autoFixOnFormat = true,
        filetypes = filetypes,
      },
    },
  })
end

return _M
