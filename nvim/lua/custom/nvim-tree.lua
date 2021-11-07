require('nvim-tree').setup {
  auto_close = true,
  open_on_setup = false,
  view = {
    auto_resize = true,
  },
}

-- Refresh NvimTree on file save
vim.api.nvim_command [[autocmd BufWritePost lua require'nvim-tree'.refresh()]]
