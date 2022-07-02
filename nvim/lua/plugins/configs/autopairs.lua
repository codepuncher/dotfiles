local _plugin, plugin = pcall(require, 'nvim-autopairs')
if not _plugin then
  return
end

plugin.setup({})
