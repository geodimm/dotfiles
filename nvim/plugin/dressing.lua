local status_ok, dressing, telescope_themes
status_ok, dressing = pcall(require, 'dressing')
if not status_ok then
  return
end
status_ok, telescope_themes = pcall(require, 'telescope.themes')
if not status_ok then
  return
end

dressing.setup({
  input = {
    winblend = 0,
  },
  select = {
    telescope = telescope_themes.get_cursor({}),
  },
})
