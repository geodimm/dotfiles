return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    build = 'make',
  },
  {
    'gbrlsnchs/telescope-lsp-handlers.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },
  {
    'molecule-man/telescope-menufacture',
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },
}
