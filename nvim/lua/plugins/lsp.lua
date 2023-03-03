return {
  { 'neovim/nvim-lspconfig' },
  {
    'SmiteshP/nvim-navic',
    dependencies = { 'neovim/nvim-lspconfig' },
  },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { 'kosayoda/nvim-lightbulb' },
  { 'folke/neodev.nvim' },
  { 'mfussenegger/nvim-jdtls' },
}
