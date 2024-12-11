return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      flavour = 'macchiato',
      transparent_background = true,
      integrations = {
        lsp_trouble = true,
        mason = true,
        noice = true,
        notify = true,
        which_key = true,
        grug_far = true,
      },
      custom_highlights = function(colors)
        return {
          PmenuThumb = { bg = colors.blue },
          DapUIFloatBorder = { link = 'FloatBorder' },
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
