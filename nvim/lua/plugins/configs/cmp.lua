local _cmp, cmp = pcall(require, 'cmp')
if not _cmp then
  return
end

local lspkind = require('lspkind')
local luasnip = require('luasnip')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local function tab(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end

local function shift_tab(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping(function(fallback)
      local fallback_key = vim.api.nvim_replace_termcodes('<Tab>', true, true, true)
      local resolved_key = vim.fn['copilot#Accept'](fallback)
      if fallback_key == resolved_key then
        cmp.confirm({ select = true })
      else
        vim.api.nvim_feedkeys(resolved_key, 'n', true)
      end
    end), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(tab, { 'c', 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(shift_tab, { 'c', 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'emoji' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
    { name = 'emoji' },
    { name = 'path' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      maxwidth = 50,
    }),
  },
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'emoji' },
  }),
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
    { name = 'buffer' },
  }),
})

-- cmp.setup.filetype({ 'dap-repl', 'dapui_watches' }, {
--   cmp.config.sources({
--     { name = 'dap' },
--   }),
-- })

local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
