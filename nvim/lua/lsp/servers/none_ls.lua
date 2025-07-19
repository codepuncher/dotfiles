local _plugin, plugin = pcall(require, 'null-ls')
local _M = {
  setup = function() end,
}

if not _plugin then
  return _M
end

local formatting = plugin.builtins.formatting
local diagnostics = plugin.builtins.diagnostics

_M.setup = function(on_attach)
  plugin.setup({
    debug = true,
    root_dir = require('null-ls.utils').root_pattern('.git', 'package.json', 'composer.json'),
    sources = {
      require('none-ls.code_actions.eslint_d'),

      diagnostics.actionlint,
      -- diagnostics.ansiblelint,
      -- diagnostics.chktex,
      require('none-ls.diagnostics.eslint_d'),
      diagnostics.hadolint,
      diagnostics.markdownlint,
      diagnostics.phpcs.with({
        prefer_local = './vendor/bin',
      }),
      -- diagnostics.phpmd, -- FIX: doesn't work yet.
      diagnostics.stylelint.with({
        prefer_local = './node_modules/stylelint/bin',
      }),
      diagnostics.tidy,
      diagnostics.yamllint,
      diagnostics.zsh,

      formatting.blade_formatter,
      require('none-ls.formatting.eslint_d'),
      formatting.gofmt,
      formatting.phpcbf.with({
        prefer_local = './vendor/bin',
      }),
      formatting.prettierd,
      formatting.stylelint.with({
        prefer_local = './node_modules/stylelint/bin',
      }),
      formatting.stylua,
      formatting.tidy,
    },
    on_attach = on_attach,
  })
end

return _M
