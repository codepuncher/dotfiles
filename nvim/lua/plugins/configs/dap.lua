local _plugin, plugin = pcall(require, 'dap')
if not _plugin then
  print('no dap')
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
  1,
})

plugin.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host, port = config.port })
end

plugin.configurations.lua = {
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
table.insert(plugin.configurations.go, {
  type = 'delve',
  name = 'Debug iroots site new',
  request = 'launch',
  mode = 'debug',
  program = '${fileDirname}',
  args = {
    'site',
    'new',
    '-s',
    'foo',
    '-b',
    'bar',
    '-t',
    'baz',
    '--bedrock_repo_pat',
    '1',
    '--trellis_template_vault_pass',
    '2',
  },
})

local map = function(lhs, rhs, desc)
  if desc then
    desc = '[DAP] ' .. desc
  end

  vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
end

map('<F1>', require('dap').step_back, 'step_back')
map('<F2>', require('dap').step_into, 'step_into')
map('<F3>', require('dap').step_over, 'step_over')
map('<F4>', require('dap').step_out, 'step_out')
map('<F5>', require('dap').continue, 'continue')

map('<leader>dr', require('dap').repl.open)

map('<leader>db', require('dap').toggle_breakpoint)
map('<leader>dB', function()
  require('dap').set_breakpoint(vim.fn.input('[DAP] Condition > '))
end)

map('<leader>de', require('dapui').eval)
map('<leader>dE', function()
  require('dapui').eval(vim.fn.input('[DAP] Expression > '))
end)

-- You can set trigger characters OR it will default to '.'
-- You can also trigger with the omnifunc, <c-x><c-o>
vim.cmd([[
augroup DapRepl
  au!
  au FileType dap-repl lua require('dap.ext.autocompl').attach()
augroup END
]])

local dap_ui = require('dapui')

dap_ui.setup()

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

plugin.listeners.after.event_initialized['dapui_config'] = function()
  debug_map('asdf', ":echo 'hello world<CR>", 'showing things')

  dap_ui.open()
end

plugin.listeners.before.event_terminated['dapui_config'] = function()
  debug_unmap()

  dap_ui.close()
end

plugin.listeners.before.event_exited['dapui_config'] = function()
  dap_ui.close()
end
