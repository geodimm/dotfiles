local status_ok, notify
status_ok, notify = pcall(require, 'notify')
if not status_ok then
  return
end

notify.setup({
  timeout = 1500,
  stages = 'slide',
})
