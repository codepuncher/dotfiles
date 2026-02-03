local _plugin, plugin = pcall(require, 'nvim-treesitter.configs')
if not _plugin then
  return
end

plugin.setup({
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  refactor = {
    highlight_definitions = {
      enable = true,
    },
    highlight_current_scope = {
      enabled = true,
    },
  },
  textobjects = {
    select = {
      enable = true,
    },
  },
  matchup = {
    enable = true,
  },
  tree_setter = {
    enable = true,
  },
  install = {
    'bash',
    'blade',
    'css',
    'go',
    'html',
    'hurl',
    'hurl',
    'javascript',
    'jsdoc',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'php',
    'python',
    'regex',
    'scss',
    'svelte',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vue',
    'yaml',
  },
})

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.hurl = {
  install_info = {
    url = '~/Code/misc/tree-sitter-hurl', -- or your own path, i.e. where you cloned the repository
    files = { 'src/parser.c' },
    branch = 'main',
    generate_requires_npm = false,
    requires_generate_from_grammar = false,
  },
  filetype = 'hurl',
}

parser_config.blade = {
  install_info = {
    url = 'https://github.com/EmranMR/tree-sitter-blade',
    files = { 'src/parser.c' },
    branch = 'main',
  },
  filetype = 'blade',
}

vim.filetype.add({
  extension = {
    hurl = 'hurl',
    blade = 'blade',
  },
})
