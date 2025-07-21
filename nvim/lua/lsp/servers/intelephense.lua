return function(capabilities)
  return {
    capabilities = capabilities,
    init_options = {
      documentFormatting = false,
      documentFormattingProvider = false,
      documentRangeFormattingProvider = false,
    },
    filetypes = {
      'php',
      'blade',
    },
    settings = {
      intelephense = {
        format = {
          enable = false,
        },
      },
    },
  }
end
