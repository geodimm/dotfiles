return {
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    init = function()
      vim.b.miniindentscope_disable = true
    end,
    config = function()
      local icons = require('user.icons')
      local opts = {
        bigfile = {
          enabled = true,
        },
        dashboard = {
          sections = {
            { section = 'header' },
            { section = 'keys', icon = icons.ui.keyboard, indent = 2, padding = 1 },
            {
              section = 'recent_files',
              title = 'Recent Project Files',
              icon = icons.ui.history,
              file = vim.fn.fnamemodify('.', ':~'),
              limit = 5,
              cwd = true,
              indent = 2,
              padding = 1,
            },
            {
              section = 'recent_files',
              title = 'Recent Files',
              icon = icons.ui.history,
              file = vim.fn.fnamemodify('.', ':~'),
              limit = 5,
              cwd = vim.g.user_repos_dir or vim.fn.expand('$HOME/repos'),
              indent = 2,
              padding = 1,
            },
            {
              section = 'projects',
              title = 'Projects',
              icon = icons.file.directory_open,
              limit = 5,
              indent = 2,
              padding = 1,
            },
            { section = 'startup', icon = icons.ui.plug .. ' ' },
          },
        },
        gitbrowse = {
          enabled = true,
        },
        image = {
          enabled = true,
        },
        input = {
          icon_pos = 'title',
        },
        styles = {
          input = {
            relative = 'cursor',
            row = -3,
            col = 0,
            wo = {
              winhighlight = 'SnacksInputTitle:Title,SnacksInputIcon:Title',
            },
          },
        },
      }

      local keymap = require('utils.keymap')
      keymap.set({ 'n', 'v' }, '<leader>hB', Snacks.gitbrowse.open, { desc = 'Open in browser' })
      keymap.set('n', '<leader>cR', Snacks.rename.rename_file, { desc = 'Rename File' })

      keymap.register_group('<leader>t', 'Toggle')

      Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>tl')
      Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>tw')
      Snacks.toggle.diagnostics():map('<leader>td')
      Snacks.toggle.inlay_hints():map('<leader>th')

      local formattingToggle = Snacks.toggle.new({
        id = 'formatting',
        name = 'Formatting',
        get = function()
          return vim.b.formatting
        end,
        set = function(state)
          vim.b.formatting = state
        end,
      }, opts)
      formattingToggle:map('<leader>tf')

      Snacks.setup(opts)
    end,
  },
}
