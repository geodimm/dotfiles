local status_ok, gopher = pcall(require, 'gopher')
if not status_ok then
  return
end

gopher.setup({
  commands = {
    go = 'go',
    gomodifytags = 'gomodifytags',
    gotests = '~/go/bin/gotests', -- also you can set custom command path
    impl = 'impl',
    iferr = 'iferr',
  },
})
