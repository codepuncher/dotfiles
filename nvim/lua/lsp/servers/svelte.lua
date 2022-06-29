local _M = {}

_M.setup = function(on_attach, capabilities)
  require('lspconfig').svelte.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    filetypes = {
      'svelte',
    },
  })
end

return _M
