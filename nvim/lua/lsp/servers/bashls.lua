local _M = {}

_M.setup = function(on_attach, capabilities)
  require('lspconfig').bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {
      'sh',
      'bash',
    },
    flags = {
      debounce_text_changes = 150,
    },
  })
end

return _M
