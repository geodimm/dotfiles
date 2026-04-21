local M = {}

function M.setup()
  local opts = {
    flavour = 'mocha',
    transparent_background = true,
    float = {
      transparent = true,
    },
    integrations = {
      fzf = true,
      lsp_trouble = true,
      mason = true,
      noice = true,
      notify = true,
      which_key = true,
      grug_far = true,
      blink_cmp = {
        enabled = true,
        style = 'bordered',
      },
      mini = {
        enabled = true,
        indentscope_color = 'overlay2',
      },
      snacks = true,
    },
    custom_highlights = function(C)
      local O = require('catppuccin').options
      return {
        PmenuThumb = { bg = C.blue },
        BlinkCmpScrollBarThumb = { bg = C.blue },
        MarkviewCode = { bg = C.mantle },

        ['@variable.member'] = { fg = C.lavender },
        ['@module'] = { fg = C.lavender, style = O.styles.miscs or { 'italic' } },
        ['@string.special.url'] = { fg = C.rosewater, style = { 'italic', 'underline' } },
        ['@type.builtin'] = { fg = C.yellow, style = O.styles.properties or { 'italic' } },
        ['@property'] = { fg = C.lavender, style = O.styles.properties or {} },
        ['@constructor'] = { fg = C.sapphire },
        ['@keyword.operator'] = { link = 'Operator' },
        ['@keyword.export'] = { fg = C.sky, style = O.styles.keywords },
        ['@markup.strong'] = { fg = C.maroon, style = { 'bold' } },
        ['@markup.italic'] = { fg = C.maroon, style = { 'italic' } },
        ['@markup.heading'] = { fg = C.blue, style = { 'bold' } },
        ['@markup.quote'] = { fg = C.maroon, style = { 'bold' } },
        ['@markup.link'] = { link = 'Tag' },
        ['@markup.link.label'] = { link = 'Label' },
        ['@markup.link.url'] = { fg = C.rosewater, style = { 'italic', 'underline' } },
        ['@markup.raw'] = { fg = C.teal },
        ['@markup.list'] = { link = 'Special' },
        ['@tag'] = { fg = C.mauve },
        ['@tag.attribute'] = { fg = C.teal, style = O.styles.miscs or { 'italic' } },
        ['@tag.delimiter'] = { fg = C.sky },
        ['@property.css'] = { fg = C.lavender },
        ['@property.id.css'] = { fg = C.blue },
        ['@type.tag.css'] = { fg = C.mauve },
        ['@string.plain.css'] = { fg = C.peach },
        ['@constructor.lua'] = { fg = C.flamingo },
        ['@property.typescript'] = { fg = C.lavender, style = O.styles.properties or {} },
        ['@constructor.typescript'] = { fg = C.lavender },
        ['@constructor.tsx'] = { fg = C.lavender },
        ['@tag.attribute.tsx'] = { fg = C.teal, style = O.styles.miscs or { 'italic' } },
        ['@type.builtin.c'] = { fg = C.yellow, style = {} },
        ['@type.builtin.cpp'] = { fg = C.yellow, style = {} },
      }
    end,
  }
  vim.opt.background = 'dark'
  require('catppuccin').setup(opts)
  vim.cmd.colorscheme('catppuccin')
end

return M
