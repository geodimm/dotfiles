local status_ok, pets = pcall(require, 'pets')
if not status_ok then
  return
end

pets.setup({
  popup = {
    avoid_statusline = true,
  },
})
