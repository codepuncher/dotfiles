return function(capabilities)
  return {
    capabilities = capabilities,
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
  }
end
