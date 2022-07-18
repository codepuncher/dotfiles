local _plugin, plugin = pcall(require, 'lspsaga')
if not _plugin then
  return
end

plugin.init_lsp_saga({
  border_style = 'round',
  diagnostic_header = { ' ', ' ', ' ', 'ﴞ ' },
  symbol_in_winbar = {
    in_custom = false,
    enable = true,
    separator = '  ',
    show_file = true,
    click_support = false,
  },
  show_outline = {
    win_width = 50,
    jump_key = '<cr>',
  },
})
