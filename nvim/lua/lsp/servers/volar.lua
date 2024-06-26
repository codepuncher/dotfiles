local _M = {}

_M.setup = function(on_attach, capabilities)
  local typescript_path = vim.env.HOME .. '/.config/yarn/global/node_modules/typescript/lib'
  require('lspconfig').volar.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    init_options = {
      typescript = {
        tsdk = typescript_path,
      },
    },
  })
end

return _M
