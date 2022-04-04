require('nvim-tree').setup({
  auto_close = true,
  auto_reload_on_write = true,
  open_on_setup = false,
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },
  view = {
    width = 50,
    side = 'left',
    mappings = {
      list = {
        {
          key = '<C-e>',
          action = '',
        },
      },
    },
  },
  git = {
    ignore = false,
  },
})
