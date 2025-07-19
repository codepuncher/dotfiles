local _plugin, plugin = pcall(require, 'lazydev')
if not _plugin then
  return
end

plugin.setup({})

return function(capabilities)
  return {
    lspconfig = {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = {
              'vim',
            },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
      flags = {
        debounce_text_changes = 150,
      },
    },
  }
end
