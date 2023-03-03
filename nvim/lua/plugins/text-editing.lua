return {
  {
    'kylechui/nvim-surround',
    config = true,
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
