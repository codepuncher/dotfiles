require('gitsigns').setup({
  signcolumn = true,
  numhl = true,
  linehl = true,
  word_diff = true,
  current_line_blame = true,

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      end

      vim.schedule(function()
        gs.next_hunk()
      end)

      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      end

      vim.schedule(function()
        gs.prev_hunk()
      end)

      return '<Ignore>'
    end, { expr = true })
  end,
})
