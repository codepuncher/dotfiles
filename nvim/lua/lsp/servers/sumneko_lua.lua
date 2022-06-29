local _M = {}

_M.setup = function (on_attach, capabilities)
  local config = require('lua-dev').setup({
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

  require('lspconfig').sumneko_lua.setup(config)
end

return _M
