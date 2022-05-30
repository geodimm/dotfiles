local themes = require('telescope.themes')

require('dressing').setup({
  input = {
    winblend = 0,
  },
  select = {
    telescope = themes.get_cursor({}),
  },
})
