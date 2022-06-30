local _plugin, plugin = pcall(require, 'bufferline')
if not _plugin then
  return
end

plugin.setup({
  options = {
    diagnostics = 'nvim_lsp',
    show_buffer_close_icons = false,
    offsets = {
      {
        filetype = 'NvimTree',
        text = 'File Explorer',
        highlight = 'Directory',
        text_align = 'left',
      },
    },
  },
})
