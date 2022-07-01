local _plugin, plugin = pcall(require, 'gitsigns')
if not _plugin then
  return
end

plugin.setup({
  signcolumn = true,
  numhl = true,
  linehl = false,
  word_diff = false,
  current_line_blame = true,

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
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
