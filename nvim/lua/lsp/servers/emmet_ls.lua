local _M = {}

_M.setup = function(on_attach, capabilities)
  require('lspconfig').emmet_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    root_dir = function()
      return vim.loop.cwd()
    end,
  }
end

return _M
