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
    insert_only = false,
    prompt_align = 'center',
    relative = 'editor',
    prefer_width = 0.5,
  },
  select = {
    telescope = telescope_themes.get_cursor({
      layout_config = {
        width = function(_, max_columns, _)
          return math.min(max_columns, 80)
        end,
        height = function(_, _, max_lines)
          return math.min(max_lines, 15)
        end,
      },
    }),
  },
})
