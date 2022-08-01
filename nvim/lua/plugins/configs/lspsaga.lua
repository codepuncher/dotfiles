local _plugin, plugin = pcall(require, 'lspsaga')
if not _plugin then
  return
end

plugin.init_lsp_saga({
  border_style = 'rounded',
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

vim.api.nvim_create_autocmd({ 'WinEnter' }, {
  desc = 'Close lspsaga outline if is last window.',
  command = "if &filetype == 'lspsagaoutline' && winnr('$') == 1 | bdel | endif",
})
