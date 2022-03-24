local M = {}

M.git_branch_new = function()
  local branch_name = vim.fn.input('Branch name: ')
  if branch_name == nil or branch_name == '' then
    print('No branch specified')
    return
  end

  vim.api.nvim_command('redraw')
  vim.api.nvim_command('Git checkout -b ' .. branch_name)
end

return M
