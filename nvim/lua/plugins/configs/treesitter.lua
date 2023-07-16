local _plugin, plugin = pcall(require, 'nvim-treesitter.configs')
if not _plugin then
  return
end

plugin.setup({
  autotag = {
    enable = true,
  },
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
  ensure_installed = {
    'markdown',
    'markdown_inline',
    'tsx',
    'toml',
    'bash',
    'php',
    'javascript',
    'typescript',
    'jsdoc',
    'json',
    'regex',
    'lua',
    'go',
    'yaml',
    'html',
    'scss',
    'css',
    'vim',
    'vue',
    'svelte',
    'python',
  },
})
