require('nvim-tree').setup({
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

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
  nested = true,
  -- callback = function()
  --   if
  --     vim.api.nvim_win_get_number(0) == 1
  --     and vim.api.nvim_eval('bufname()') == 'NvimTree_' .. vim.api.nvim_get_current_tabpage()
  --   then
  --     vim.api.nvim_command('quit')
  --   end
  -- end,
})
