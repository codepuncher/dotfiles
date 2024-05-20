local _plugin, plugin = pcall(require, 'nvim-ts-autotag')
if not _plugin then
  return
end

plugin.setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true,
  },
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
