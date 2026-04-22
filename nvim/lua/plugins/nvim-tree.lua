local M = {}

function M.setup()
  local keymap = require('utils.keymap')
  local icons = require('user.icons')

  local prev = { new_name = '', old_name = '' }
  vim.api.nvim_create_autocmd('User', {
    pattern = 'NvimTreeSetup',
    callback = function()
      local events = require('nvim-tree.api').events
      events.subscribe(events.Event.NodeRenamed, function(data)
        if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
          prev = { new_name = data.new_name, old_name = data.old_name }
          Snacks.rename.on_rename_file(data.old_name, data.new_name)
        end
      end)
    end,
  })

  keymap.set('n', '<leader>fl', function()
    require('nvim-tree.api').tree.open({ focus = true, find_file = true })
  end, { desc = 'Locate file in explorer' })
  keymap.set('n', '<leader>fe', function()
    require('nvim-tree.api').tree.toggle()
  end, { desc = 'Open file explorer' })

  require('nvim-tree').setup({
    hijack_cursor = true,
    diagnostics = { enable = true, icons = icons.nerdtree },
    respect_buf_cwd = true,
    on_attach = function(bufnr)
      local api = require('nvim-tree.api')

      local function tree_opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      api.map.on_attach.default(bufnr)

      vim.keymap.set('n', '<CR>', api.node.open.edit, tree_opts('Open'))
      vim.keymap.set('n', 'l', api.node.open.edit, tree_opts('Open'))
      vim.keymap.set('n', 'o', api.node.open.edit, tree_opts('Open'))
      vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, tree_opts('Open'))
      vim.keymap.set('n', 'h', api.node.navigate.parent_close, tree_opts('Close Directory'))
    end,
    renderer = {
      add_trailing = true,
      highlight_git = 'name',
      indent_markers = { enable = true },
      special_files = {
        'Makefile',
        'README.md',
        'go.mod',
        'go.sum',
      },
      icons = {
        glyphs = {
          git = {
            unstaged = icons.git.status.modified,
            staged = icons.git.status.added,
            unmerged = icons.git.status.unmerged,
            renamed = icons.git.status.renamed,
            untracked = icons.git.status.untracked,
            deleted = icons.git.status.deleted,
            ignored = icons.git.status.ignored,
          },
        },
      },
    },
    git = {
      ignore = false,
      timeout = 5000,
    },
    view = {
      adaptive_size = true,
      preserve_window_proportions = true,
      width = 40,
      side = 'left',
    },
    actions = {
      file_popup = {
        open_win_config = {
          border = 'rounded',
        },
      },
      open_file = {
        window_picker = {
          enable = false,
        },
      },
    },
  })
end

return M
