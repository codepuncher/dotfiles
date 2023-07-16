local _plugin, plugin = pcall(require, 'lspsaga')
if not _plugin then
  return
end

plugin.setup({
  border = 'rounded',
  devicon = true,
  kind = { ' ', ' ', ' ', 'ﴞ ' },
  symbol_in_winbar = {
    enable = true,
    separator = ' › ',
    hide_keyword = false,
    show_file = true,
    folder_level = 1,
    color_mode = true,
  },
  code_action = {
    num_shortcut = true,
    show_server_name = true,
    extend_gitsigns = true,
  },
  outline = {
    win_width = 50,
    keys = {
      jump = '<cr>',
    },
  },
})

vim.api.nvim_create_autocmd({ 'WinEnter' }, {
  desc = 'Close lspsaga outline if is last window.',
  command = "if &filetype == 'lspsagaoutline' && winnr('$') == 1 | bdel | endif",
})
