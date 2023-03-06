local _plugin, plugin = pcall(require, 'nvim-tree')
if not _plugin then
  return
end

plugin.setup({
  auto_reload_on_write = true,
  sync_root_with_cwd = true,
  view = {
    adaptive_size = true,
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
  renderer = {
    highlight_git = true,
    special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'composer.json', 'package.json' },
  },
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
  filters = {
    dotfiles = false,
    custom = {
      '^\\.git$',
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
