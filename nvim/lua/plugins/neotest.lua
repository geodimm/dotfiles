return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-go',
    },
    init = function()
      local keymap = require('utils.keymap')
      keymap.register_group('<leader>r', 'Run test', {})
    end,
    keys = {
      {
        '<leader>rn',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run the nearest test',
      },
      {
        '<leader>ra',
        function()
          vim.ui.input({ prompt = 'Extra go test args: ' }, function(input)
            require('neotest').run.run({ extra_args = vim.split(input, ' ') })
          end)
        end,
        desc = 'Run with args',
      },
      {
        '<leader>rf',
        function()
          require('neotest').run.run(vim.fn.expand('%'))
        end,
        desc = 'Run the current file',
      },
      {
        '<leader>ro',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = 'Toggle test output',
      },
      {
        '<leader>rs',
        function()
          require('neotest').summary.toggle()
        end,
        desc = 'Toggle test summary',
      },
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-go'),
        },
      })
    end,
  },
}
