local _M = {}

_M.setup = function(on_attach, capabilities)
  require('lspconfig').jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      json = {
        -- Schemas https://www.schemastore.org/json/
        schemas = {
          { fileMatch = { 'package.json' }, url = 'https://json.schemastore.org/package.json' },
          { fileMatch = { 'tsconfig*.json' }, url = 'https://json.schemastore.org/tsconfig.json' },
          {
            fileMatch = { '.prettierrc', '.prettierrc.json', 'prettier.config.json' },
            url = 'https://json.schemastore.org/prettierrc.json',
          },
          { fileMatch = { '.eslintrc', '.eslintrc.json' }, url = 'https://json.schemastore.org/eslintrc.json' },
          {
            fileMatch = { '.babelrc', '.babelrc.json', 'babel.config.json' },
            url = 'https://json.schemastore.org/babelrc.json',
          },
          {
            fileMatch = { '.stylelintrc', '.stylelintrc.json', 'stylelint.config.json' },
            url = 'http://json.schemastore.org/stylelintrc.json',
          },
          {
            fileMatch = { 'composer.json' },
            url = 'https://raw.githubusercontent.com/composer/composer/master/res/composer-schema.json',
          },
        },
      },
    },
  })
end

return _M
