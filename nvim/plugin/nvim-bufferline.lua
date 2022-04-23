local bufferline, wk, status_ok
status_ok, bufferline = pcall(require, 'bufferline')
if not status_ok then
  return
end
status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

local lsp_icons = require('config.icons').lsp

bufferline.setup({
  options = {
    diagnostics = 'nvim_lsp',
    max_name_length = 20,
    diagnostics_indicator = function(count, level)
      return ' ' .. lsp_icons[level] .. ' ' .. count
    end,
    offsets = {
      {
        filetype = 'NvimTree',
        text = 'File Explorer',
        text_align = 'center',
      },
    },
  },
})

vim.api.nvim_set_keymap('n', '[b', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']b', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })

wk.register({
  ['[b'] = { 'Previous buffer' },
  [']b'] = { 'Next buffer' },
})
