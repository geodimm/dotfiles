local telescope_themes, status_ok
status_ok, telescope_themes = pcall(require, 'telescope.themes')
if not status_ok then
  return
end

require('dressing').setup({
  input = {
    winblend = 0,
  },
  select = {
    telescope = telescope_themes.get_cursor({}),
  },
})
