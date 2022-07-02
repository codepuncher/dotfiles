local _plugin, plugin = pcall(require, 'lspsaga')
if not _plugin then
  return
end

plugin.init_lsp_saga({
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = 'round',
})
