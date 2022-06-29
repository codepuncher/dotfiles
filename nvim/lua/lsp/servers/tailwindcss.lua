local _M = {}

_M.setup = function(on_attach, capabilities)
  require('lspconfig').tailwindcss.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {
      'html',
      'css',
    },
  })
end

return _M
