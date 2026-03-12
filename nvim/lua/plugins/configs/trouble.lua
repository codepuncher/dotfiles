local _plugin, plugin = pcall(require, 'trouble')
if not _plugin then
  return
end

plugin.setup({
  mode = 'document_diagnostics',
  modes = {
    diagnostics = {
      auto_open = false,
      auto_close = true,
      auto_preview = true,
      auto_refresh = true,
      focus = true,
    },
  },
})
