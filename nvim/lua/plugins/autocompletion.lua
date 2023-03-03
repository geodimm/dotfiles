return {
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-nvim-lua' },
  { 'petertriho/cmp-git', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'L3MON4D3/LuaSnip' },
  {
    'saadparwaiz1/cmp_luasnip',
    dependencies = { 'hrsh7th/nvim-cmp', 'L3MON4D3/LuaSnip' },
  },
  { 'rafamadriz/friendly-snippets' },
  { 'onsails/lspkind-nvim' },
}
