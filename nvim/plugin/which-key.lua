local status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

local icons = require('user.icons')
local key_labels = {
  ['<space>'] = icons.keyboard.Space,
  ['<cr>'] = icons.keyboard.Return,
  ['<bs>'] = icons.keyboard.Backspace,
  ['<tab>'] = icons.keyboard.Tab,
}
for k, v in pairs(key_labels) do
  key_labels[k:upper()] = v
end

wk.setup({
  icons = {
    group = icons.ui.list_ul .. ' ',
    breadcrumb = icons.ui.breadcrumb,
  },
  key_labels = key_labels,
  window = { border = 'rounded', margin = { 0, 0, 0, 0 }, padding = { 1, 1, 1, 1 } },
})
