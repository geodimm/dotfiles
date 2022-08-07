local status_ok, lualine = pcall(require, 'lualine')
if not status_ok then
  return
end

local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ''
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and '' or '…')
    end
    return str
  end
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local patched_theme = vim.tbl_deep_extend('force', require('lualine.themes.auto'), { normal = { c = { bg = 'none' } } })
local separator = { left = '', right = '' }

lualine.setup({
  options = {
    theme = patched_theme,
    section_separators = { left = '', right = '' },
    component_separators = { left = '|', right = '|' },
    icons_enabled = true,
    globalstatus = true,
  },
  extensions = { 'nvim-tree', 'fugitive', 'quickfix', 'toggleterm' },
  sections = {
    lualine_a = { { 'mode', upper = true, separator = separator } },
    lualine_b = {
      {
        'b:gitsigns_head',
        icon = '',
        fmt = trunc(100, 10, nil, false),
        padding = { left = 1, right = 1 },
      },
      { 'diff', source = diff_source },
    },
    lualine_c = {
      {
        'filename',
        file_status = true,
        color = function(_)
          return vim.bo.modified and 'WarningMsg' or ''
        end,
        symbols = {
          modified = ' ﱐ',
          readonly = ' ',
          unnamed = '[No name]',
        },
      },
      { 'diagnostics', sources = { 'nvim_diagnostic' } },
    },
    lualine_x = { 'filetype' },
    lualine_y = { { 'encoding', padding = { left = 1, right = 1 } }, 'fileformat' },
    lualine_z = {
      { 'progress', padding = { left = 1, right = 0 } },
      { 'location', padding = { left = 0, right = 1 }, separator = separator },
    },
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        show_filename_only = true,
        show_modified_status = true,
        filetype_names = {
          NvimTree = 'NvimTree',
          TelescopePrompt = 'Telescope',
          packer = 'Packer',
          alpha = 'Alpha',
        },
        symbols = {
          modified = ' ﱐ',
          alternate_file = '',
          directory = ' ',
        },
        separator = separator,
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { { 'tabs', separator = separator } },
  },
})
