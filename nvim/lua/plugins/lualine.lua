return {
  {
    'hoob3rt/lualine.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local lualine = require('lualine')
      local strings = require('plenary.strings')
      local icons = require('user.icons')
      local colors = require('utils.color').colors(vim.g.colors_name)

      local function append_whitespace(v)
        return v .. ' '
      end

      local function diff_source()
        ---@diagnostic disable-next-line: undefined-field
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end

      local section_separator = {
        left = icons.powerline.left_half_circle_thick,
        right = icons.powerline.right_half_circle_thick,
      }

      local space = {
        function()
          return ' '
        end,
        padding = 0,
      }

      local theme = require('lualine.themes.' .. vim.g.colors_name)

      local winbar = {
        lualine_c = {
          {
            require('user.lualine.components.lsp_navic'),
            cond = package.loaded['nvim-navic'] and require('nvim-navic').is_available,
          },
        },
      }

      lualine.setup({
        options = {
          theme = vim.g.colors_name,
          section_separators = {
            left = icons.powerline.right_half_circle_thick,
            right = icons.powerline.left_half_circle_thick,
          },
          component_separators = '',
          icons_enabled = true,
          globalstatus = true,
          disabled_filetypes = {
            winbar = { 'NvimTree', 'alpha', 'gitcommit' },
          },
        },
        extensions = { 'nvim-tree', 'fugitive', 'quickfix', 'toggleterm' },
        sections = {
          lualine_a = {
            {
              'mode',
              separator = section_separator,
              padding = 0,
            },
          },
          lualine_b = {},
          lualine_c = {
            space,
            {
              package.loaded.gitsigns and 'b:gitsigns_head' or 'branch',
              fmt = function(str)
                return strings.truncate(str, 10, nil, 1)
              end,
              icon = icons.git.branch,
              color = { fg = theme.normal.b.fg, bg = theme.normal.b.bg },
              separator = section_separator,
              padding = 0,
            },
            {
              'diff',
              source = package.loaded.gitsigns and diff_source or nil,
              symbols = vim.tbl_map(append_whitespace, icons.git.diff),
              color = { bg = theme.normal.b.bg },
              separator = section_separator,
              padding = { left = 1 },
            },
            space,
            {
              'filetype',
              icon_only = true,
              icon = { align = 'left' },
              color = {},
              separator = section_separator,
              padding = 0,
            },
            {
              'filename',
              file_status = true,
              newfile_status = true,
              symbols = icons.file,
              color = function()
                return vim.bo.modified and { fg = colors.yellow } or {}
              end,
              separator = section_separator,
              padding = { left = 1 },
            },
          },
          lualine_x = {
            {
              'encoding',
              cond = function()
                return vim.opt.fileencoding:get() ~= 'utf-8'
              end,
              color = { fg = colors.bg, bg = colors.magenta },
              separator = section_separator,
              padding = 0,
            },
            {
              'fileformat',
              cond = function()
                return vim.bo.fileformat ~= 'unix'
              end,
              color = { fg = colors.bg, bg = colors.magenta },
              separator = section_separator,
            },
            space,
            {
              function()
                return 'TS'
              end,
              icon = icons.ui.tree,
              color = function()
                local ts = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] or {}
                if vim.tbl_isempty(ts) then
                  return { bg = theme.normal.b.bg, fg = colors.grey }
                end

                return { bg = colors.green, fg = theme.normal.b.bg }
              end,
              separator = section_separator,
              padding = 0,
            },
            space,
            {
              require('user.lualine.components.lsp_clients'),
              progress = {
                colors = {
                  inactive = theme.normal.b.fg,
                  loading = colors.yellow,
                  done = colors.green,
                },
              },
              names = {
                colors = {
                  inactive = theme.normal.b.fg,
                  active = theme.normal.b.fg,
                },
              },
              color = { fg = theme.normal.b.fg, bg = theme.normal.b.bg },
              separator = section_separator,
              padding = 0,
            },
            {
              'diagnostics',
              sources = { 'nvim_lsp' },
              symbols = vim.tbl_map(append_whitespace, icons.lsp),
              color = { fg = theme.normal.b.fg, bg = theme.normal.b.bg },
              separator = section_separator,
              padding = { left = 1 },
            },
            space,
          },
          lualine_y = {},
          lualine_z = {
            {
              'progress',
              fmt = function()
                return '%P/%L'
              end,
              separator = section_separator,
              padding = 0,
            },
            space,
            {
              'location',
              separator = section_separator,
              padding = 0,
            },
          },
        },
        tabline = {
          lualine_a = {
            {
              'buffers',
              mode = 4,
              show_filename_only = true,
              show_modified_status = true,
              filetype_names = {
                NvimTree = 'NvimTree',
                TelescopePrompt = 'Telescope',
                lazy = 'Lazy',
                alpha = 'Alpha',
              },
              buffers_color = {
                active = { fg = colors.bg, bg = colors.blue },
                inactive = { fg = colors.blue, bg = colors.bg },
              },
              symbols = {
                modified = ' ' .. icons.file.modified,
                alternate_file = '',
                directory = icons.file.directory,
              },
              separator = section_separator,
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        winbar = winbar,
        inactive_winbar = winbar,
      })
    end,
  },
}
