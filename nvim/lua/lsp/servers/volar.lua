local _M = {}

_M.setup = function(on_attach, capabilities)
  require('lspconfig').volar.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    init_options = {
      typescript = {
        tsdk = '/home/work/.config/yarn/global/node_modules/typescript/lib',
      },
    },
  })
end

return _M
