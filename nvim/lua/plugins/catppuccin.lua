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
        nvimtree = true,
        navic = {
          enabled = true,
        },
        mason = true,
        notify = true,
        which_key = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
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
