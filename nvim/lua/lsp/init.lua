local _lspconfig = pcall(require, 'lspconfig')
if not _lspconfig then
  return
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
        -- filter = function(client)
        --   return client.name == 'null-ls'
        -- end,
      })
    end
  end,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = {
  'ansiblels',
  'bashls',
  'dockerls',
  -- 'eslint',
  'gopls',
  'html',
  'intelephense',
  'jsonls',
  'lemminx',
  'lua_ls',
  'pyright',
  'rust_analyzer',
  'stylelint_lsp',
  'ts_ls',
  'vue_ls',
  'yamlls',
  'tailwindcss',
}
for _, server in pairs(servers) do
  local _config, config = pcall(require, 'lsp.servers.' .. server)
  if _config then
    vim.lsp.config(server, config(capabilities))
    vim.lsp.enable(server)
  else
    vim.lsp.config(server, {
      capabilities = capabilities,
    })
    vim.lsp.enable(server)
  end
end

require('lsp.servers.none_ls').setup()

return
