local _impatient, impatient = pcall(require, 'impatient')
if _impatient then
  impatient.enable_profile()
end

require('plugins')
require('settings')
require('keymappings')
require('lsp')
