vim.filetype.add({
  filename = {
    Tiltfile = 'starlark',
    tiltfile = 'starlark',
  },
  pattern = {
    ['.*/.*Tiltfile.*'] = 'starlark',
    ['.*/.*tiltfile.*'] = 'starlark',
  },
})
