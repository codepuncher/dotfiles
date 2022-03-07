require('nvim-tree').setup({
  auto_close = true,
  open_on_setup = false,
  -- diagnostics = {enable = true},
  update_focused_file = { enable = true, update_cwd = false, ignore_list = {} },
  git = { ignore = false },
  view = { auto_resize = true, side = 'left', width = 50 },
})

-- Refresh NvimTree on file save
vim.api.nvim_command([[autocmd BufWritePost lua require'nvim-tree'.refresh()]])
