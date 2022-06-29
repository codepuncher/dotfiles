local _M = {}

_M.setup = function(on_attach, capabilities)
  require('lspconfig').pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  })
end

return _M
