local _M = {}

_M.setup = function (on_attach, capabilities)
  require('lspconfig').ltex.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ltex = {
        language = 'en',
      },
    },
  })
end

return _M
