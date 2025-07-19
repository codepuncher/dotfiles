return function(capabilities)
  return {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = lspconfig.util.root_pattern('composer.json', '.git', 'wp-config.php')(pattern)

      -- prefer cwd if root is a descendant
      return lspconfig.util.path.is_descendant(cwd, root) and cwd or root
    end,
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
  }
end
