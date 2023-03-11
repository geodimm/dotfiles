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
      },
    },
    config = function(plugin, opts)
      local cp = require('catppuccin.palettes').get_palette()

      vim.opt.background = 'dark'
      -- Customise colorscheme highlight groups
      vim.api.nvim_create_augroup('user_customise_colorscheme', { clear = true })
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = 'user_customise_colorscheme',
        desc = 'customise the colorscheme highlights',
        pattern = '*',
        callback = function()
          vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = cp.blue })
          vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'FloatBorder' })
        end,
      })

      require(plugin.name).setup(opts)
      vim.cmd('colorscheme catppuccin')
    end,
  },
}
