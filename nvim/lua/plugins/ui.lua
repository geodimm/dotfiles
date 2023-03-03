return {
  { 'kyazdani42/nvim-web-devicons' },
  { 'norcalli/nvim-colorizer.lua' },
  { 'goolord/alpha-nvim' },
  { 'stevearc/dressing.nvim' },
  { 'rcarriga/nvim-notify' },
  { 'folke/which-key.nvim' },
  {
    'folke/trouble.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
  },
  {
    'akinsho/nvim-toggleterm.lua',
    branch = 'main',
  },
  {
    'windwp/nvim-spectre',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
    },
  },
  {
    'giusgad/pets.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'edluffy/hologram.nvim',
    },
  },
}
