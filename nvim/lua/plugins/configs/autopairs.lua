local _plugin, plugin = pcall(require, 'nvim-autopairs')
if not _plugin then
  return
end

plugin.setup({
  check_ts = true,
  ts_config = {
    lua = { 'string' },
    javascript = { 'template_string' },
  },
})
