local _plugin, plugin = pcall(require, 'neodev')
if not _plugin then
  return
end

plugin.setup({})

local _M = {}

_M.setup = function(on_attach, capabilities)
  require('lspconfig').lua_ls.setup({
    lspconfig = {
      on_attach = on_attach,
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
  })
end

return _M
