local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('WriteAndExecute', { clear = true }),
  pattern = 'rsync_*',
  callback = function()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'output of: %' })
    vim.fn.jobstart({ '%' }, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end,
      on_stderr = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end,
    })
  end,
})
