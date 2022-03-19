vim.api.nvim_exec(
  [[
augroup update_lightbulb
    autocmd!
    autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
    augroup end
]],
  false
)
