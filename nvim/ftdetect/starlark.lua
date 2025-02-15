vim.filetype.add({
  pattern = {
    ['.*/.*Tiltfile.*'] = 'starlark',
    ['.*/.*tiltfile.*'] = 'starlark',
  },
})
