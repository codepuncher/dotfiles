local _plugin, plugin = pcall(require, 'lualine')
if not _plugin then
  return
end

plugin.setup({
  options = {
    theme = 'tokyonight',
  },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
      },
    },
  },
})
