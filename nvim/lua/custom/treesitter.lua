if not vim.fn.exists('g:loaded_nvim_treesitter') then
  return
end

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
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
  },
}
