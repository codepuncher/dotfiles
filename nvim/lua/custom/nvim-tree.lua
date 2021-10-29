require'nvim-tree'.setup {
  auto_close = true,
  open_on_setup = false,
  view = {
    auto_resize = true,
  },
}

-- Refresh NvimTree on file save
vim.api.nvim_command [[autocmd BufWritePost lua require'nvim-tree'.refresh()]]

local view = require'nvim-tree.view'
local tree = {}
tree.toggle = function()
  if view.win_open() then
    require'nvim-tree'.close()
    require'bufferline.state'.set_offset(0)
  else
    require'bufferline.state'.set_offset(30, 'File Explorer')
    require'nvim-tree'.find_file(true)
  end
  require'bufferline.state'.set_offset(30, 'File Explorer')
end

return tree
