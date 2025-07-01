local _M = {}

_M.setup = function(on_attach, capabilities)
  require('lspconfig').ts_ls.setup({
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = '/usr/local/lib/node_modules/@vue/typescript-plugin',
          languages = { 'javascript', 'typescript', 'vue' },
        },
      },
    },
    filetypes = {
      'javascript',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'vue',
    },
  })
end

return _M
