local _plugin, plugin = pcall(require, 'none-ls')
local _M = {
  setup = function() end,
}

if not _plugin then
  return _M
end

local formatting = plugin.builtins.formatting
local diagnostics = plugin.builtins.diagnostics
local code_actions = plugin.builtins.code_actions

_M.setup = function(on_attach)
  plugin.setup({
    debug = true,
    root_dir = require('none-ls.utils').root_pattern('.git', 'package.json', 'composer.json'),
    sources = {
      code_actions.eslint_d,
      code_actions.shellcheck,

      diagnostics.actionlint,
      -- diagnostics.ansiblelint,
      diagnostics.chktex,
      diagnostics.eslint_d,
      diagnostics.hadolint,
      diagnostics.markdownlint,
      diagnostics.phpcs.with({
        prefer_local = './vendor/bin',
      }),
      -- diagnostics.phpmd, -- FIX: doesn't work yet.
      diagnostics.shellcheck,
      diagnostics.stylelint.with({
        prefer_local = './node_modules/stylelint/bin',
      }),
      diagnostics.tidy,
      diagnostics.yamllint,
      diagnostics.zsh,

      formatting.blade_formatter,
      formatting.eslint_d,
      formatting.gofmt,
      formatting.phpcbf.with({
        prefer_local = './vendor/bin',
      }),
      formatting.prettierd,
      formatting.stylelint.with({
        prefer_local = './node_modules/stylelint/bin',
      }),
      formatting.stylua,
      formatting.shfmt.with({
        filetypes = {
          'sh',
          'bash',
          'zsh',
        },
      }),
      formatting.tidy,
    },
    on_attach = on_attach,
  })
end

return _M
