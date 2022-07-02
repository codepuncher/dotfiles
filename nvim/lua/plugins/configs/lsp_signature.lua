local _plugin, plugin = pcall(require, 'lsp_signature')
if not _plugin then
  return
end

plugin.setup({
  debug = true,
  hint_enable = true,
  handler_opts = {
    border = 'single',
  },
  max_width = 80,
  transparency = 50,
})
