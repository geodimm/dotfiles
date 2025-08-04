return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
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
      custom_highlights = function(colors)
        return {
          PmenuThumb = { bg = colors.blue },
          BlinkCmpScrollBarThumb = { bg = colors.blue },
        }
      end,
    },
    config = function(plugin, opts)
      vim.opt.background = 'dark'
      require(plugin.name).setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end,
  },
}
