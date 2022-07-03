local _plugin, plugin = pcall(require, 'lspsaga')
if not _plugin then
  return
end

plugin.init_lsp_saga({
  border_style = 'round',
  diagnostic_header = { ' ', ' ', ' ', 'ﴞ ' },
  symbol_in_winbar = true,
  winbar_separator = '>',
  winbar_show_file = true,
})
