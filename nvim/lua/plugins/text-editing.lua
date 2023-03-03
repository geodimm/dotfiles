return {
  {
    'echasnovski/mini.surround',
    opts = {
      highlight_duration = 1000,
    },
    config = function(_, opts)
      require('mini.surround').setup(opts)
    end,
  },
  {
    'echasnovski/mini.comment',
    config = function()
      require('mini.comment').setup()
    end,
  },
  {
    'echasnovski/mini.align',
    config = function()
      require('mini.align').setup()
    end,
  },
}
