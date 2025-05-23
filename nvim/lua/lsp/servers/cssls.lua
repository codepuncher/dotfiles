local _M = {}
--Enable (broadcasting) snippet capability for completion
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

_M.setup = function(on_attach, capabilities)
  require('lspconfig').cssls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    init_options = {
      provideFormatter = false,
    },
  })
end

return _M
