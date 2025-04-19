return {
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      workspace = {
        checkThirdParty = false,
      },
      format = { enable = false },
      diagnostics = {
        globals = { 'vim', 'Snacks' },
      },
    },
  },
}
