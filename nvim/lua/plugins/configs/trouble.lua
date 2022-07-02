local _plugin, plugin = pcall(require, 'trouble')
if not _plugin then
  return
end

plugin.setup({
  auto_open = false,
  auto_close = true,
  auto_preview = false,
  mode = 'document_diagnostics',
})
