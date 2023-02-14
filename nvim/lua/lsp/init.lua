local _lspconfig = pcall(require, 'lspconfig')
if not _lspconfig then
  return
end

local formatGroup = vim.api.nvim_create_augroup('LspFormatting', {})
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr,
    filter = function(client)
      return client.name ~= 'tsserver' and client.name ~= 'intelephense'
    end,
  })
end
local on_attach = function(client, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local opts = {
    noremap = true,
    silent = true,
  }

  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  map('n', '<space><space>', '<cmd>Lspsaga signature_help<CR>', opts)
  map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  map('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  map('n', '<space>rn', '<cmd>Lspsaga rename<CR>', opts)
  map('n', '<space>ca', '<cmd>Lspsaga code_action<CR>', opts)
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  map('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = formatGroup, buffer = bufnr })
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
      group = formatGroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr)
      end,
    })
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local _cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if _cmp_nvim_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities()
end

local servers = {
  'ansiblels',
  'bashls',
  'cssls',
  'dockerls',
  'eslint',
  'gopls',
  'html',
  'intelephense',
  'jsonls',
  'lemminx',
  'pyright',
  'stylelint_lsp',
  'lua_ls',
  'tsserver',
  'yamlls',
  'null_ls',
  -- 'tailwindcss',
}
for _, server in pairs(servers) do
  local _config, config = pcall(require, 'lsp.servers.' .. server)
  if not _config then
    return
  end

  config.setup(on_attach, capabilities)
end

return
