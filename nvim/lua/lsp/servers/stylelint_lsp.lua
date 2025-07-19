return function(capabilities)
  local filetypes = {
    'sass',
    'scss',
    'postcss',
  }

  return {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    filetypes = filetypes,
    settings = {
      stylelintplus = {
        autoFixOnSave = true,
        autoFixOnFormat = true,
        filetypes = filetypes,
      },
    },
  }
end
