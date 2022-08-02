local _dap, dap = pcall(require, 'dap')
if not _dap then
  return
end

require('nvim-dap-virtual-text').setup({
  enabled = true,
  enabled_commands = false,
  highlight_changed_variables = true,
  highlight_new_as_changed = true,
  commented = false,
  show_stop_reason = true,
  virt_text_pos = 'eol',
  all_frames = false,
})

dap.set_log_level('DEBUG')

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host, port = config.port })
end

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
    host = function()
      return '127.0.0.1'
    end,
    port = function()
      local val = 54231
      return val
    end,
  },
}

-- This will configure Delve for us with a default configuration.
require('dap-go').setup()
-- Now we can append our own additional configurations.
table.insert(dap.configurations.go, {
  type = 'go',
  name = 'Debug iroots site new',
  request = 'launch',
  cwd = '${workspaceFolder}',
  program = '${fileDirname}',
  args = {
    'site',
    'new',
    '-s',
    'foo',
    '-b',
    'www.foo.bar-bedrock',
    '-t',
    'www.foo.bar-trellis',
    '--bedrock_repo_pat',
    '1',
    '--trellis_template_vault_pass',
    '2',
  },
})

local dap_ui = require('dapui')
dap_ui.setup()

local map = function(lhs, rhs, desc)
  if desc then
    desc = '[DAP] ' .. desc
  end

  vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
end

map('<F1>', dap.step_back, 'step_back')
map('<F2>', dap.step_into, 'step_into')
map('<F3>', dap.step_over, 'step_over')
map('<F4>', dap.step_out, 'step_out')
map('<F5>', dap.continue, 'continue')

map('<leader>dr', dap.repl.open)

map('<leader>db', dap.toggle_breakpoint)
map('<leader>dB', function()
  require('dap').set_breakpoint(vim.fn.input('[DAP] Condition > '))
end)

map('<leader>de', dap_ui.eval)
map('<leader>dE', function()
  dap_ui.eval(vim.fn.input('[DAP] Expression > '))
end)

-- You can set trigger characters OR it will default to '.'
-- You can also trigger with the omnifunc, <c-x><c-o>
vim.cmd([[
augroup DapRepl
  au!
  au FileType dap-repl lua require('dap.ext.autocompl').attach()
augroup END
]])

local original = {}
local debug_map = function(lhs, rhs, desc)
  local keymaps = vim.api.nvim_get_keymap('n')
  original[lhs] = vim.tbl_filter(function(v)
    return v.lhs == lhs
  end, keymaps)[1] or true

  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

local debug_unmap = function()
  for k, v in pairs(original) do
    if v == true then
      vim.keymap.del('n', k)
    else
      local rhs = v.rhs

      v.lhs = nil
      v.rhs = nil
      v.buffer = nil
      v.mode = nil
      v.sid = nil
      v.lnum = nil

      vim.keymap.set('n', k, rhs, v)
    end
  end

  original = {}
end

dap.listeners.after.event_initialized['dapui_config'] = function()
  debug_map('asdf', ":echo 'hello world<CR>", 'showing things')

  dap_ui.open()
end

dap.listeners.before.event_terminated['dapui_config'] = function()
  debug_unmap()

  dap_ui.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
  dap_ui.close()
end
