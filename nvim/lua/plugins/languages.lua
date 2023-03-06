return {
  {
    'olexsmir/gopher.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      commands = {
        go = 'go',
        gomodifytags = 'gomodifytags',
        gotests = 'gotests',
        impl = 'impl',
        iferr = 'iferr',
      },
    },
  },
  { 'towolf/vim-helm' },
  { 'bfrg/vim-jq' },
  { 'mracos/mermaid.vim' },
  { 'bfontaine/Brewfile.vim' },
}
