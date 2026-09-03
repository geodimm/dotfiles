return {
  settings = {
    Lua = {
      codeLens = {
        enable = true,
      },
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
