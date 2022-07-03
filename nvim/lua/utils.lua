local M = {
  git_branch_new = function()
    local branch_name = vim.fn.input('Branch name: ')
    if branch_name == nil or branch_name == '' then
      print('No branch specified')
      return
    end

    vim.api.nvim_command('redraw')
    vim.api.nvim_command('Git checkout -b ' .. branch_name)
  end,

  is_empty = function(s)
    return s == nil or s == ''
  end,

  get_buf_option = function(opt)
    local ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
    if not ok then
      return nil
    end

    return buf_option
  end,
}

return M
