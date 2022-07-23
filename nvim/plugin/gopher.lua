require('gopher').setup({
  commands = {
    go = 'go',
    gomodifytags = 'gomodifytags',
    gotests = '~/go/bin/gotests', -- also you can set custom command path
    impl = 'impl',
    iferr = 'iferr',
  },
})
