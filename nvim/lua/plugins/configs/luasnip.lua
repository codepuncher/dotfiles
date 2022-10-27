local _plugin, plugin = pcall(require, 'luasnip')
if not _plugin then
  return
end

local s = plugin.snippet
local s = pl
local sn = plugin.snippet_node
local t = plugin.text_node
local i = plugin.insert_node
local f = plugin.function_node
local c = plugin.choice_node
local d = plugin.dynamic_node
local r = plugin.restore_node

plugin.add_snippets('php', {
  s('bb-link-field', {}),
}, {
  key = 'php',
})
