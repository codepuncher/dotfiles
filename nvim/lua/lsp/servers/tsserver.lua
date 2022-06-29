local _M = {}

_M.setup = function(on_attach, capabilities)
  require('typescript').setup({
    server = {
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormatting = false
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
      filetypes = {
        'javascript',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
      },
    },
  })
end

return _M
