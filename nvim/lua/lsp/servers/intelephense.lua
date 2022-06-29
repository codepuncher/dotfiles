local _M = {}

_M.setup = function (on_attach, capabilities)
  require('lspconfig').intelephense.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    init_options = {
      documentFormatting = false,
    },
    filetypes = {
      'php',
      'blade',
    },
    settings = {
      format = {
        enable = false,
      },
      intelephense = {
        format = {
          enable = false,
        },
      },
    },
  })
end

return _M
