local _plugin, plugin = pcall(require, 'nvim-ts-autotag')
if not _plugin then
  return
end

plugin.setup({
  enable = true,
  filetypes = {
    'blade', --Not working
    'html',
    'javascript',
    'javascriptreact',
    'php', --Not working
    'typescriptreact',
    'svelte',
    'vue',
  },
})
