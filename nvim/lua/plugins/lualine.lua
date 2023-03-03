return {
  {
    'hoob3rt/lualine.nvim',
    config = function()
      local lualine = require('lualine')
      local navic = require('nvim-navic')
      local icons = require('user.icons')
      local colors = require('utils.color').colors(vim.g.colors_name)

      local function map(tbl, f)
        local t = {}
        for k, v in pairs(tbl) do
          t[k] = f(v)
        end
        return t
      end

      local function append_whitespace(v)
        return v .. ' '
      end

      local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
        return function(str)
          local win_width = vim.fn.winwidth(0)
          if hide_width and win_width < hide_width then
            return ''
          elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
            return str:sub(1, trunc_len) .. (no_ellipsis and '' or '…')
          end
          return str
        end
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

      -- Override 'encoding': Don't display if encoding is UTF-8.
      local function encoding()
        ---@diagnostic disable-next-line: undefined-field
        local fenc = vim.opt.fileencoding:get()
        if fenc == 'utf-8' then
          return ''
        end

        return fenc
      end

      -- Override 'fileformat': Don't display if &ff is unix.
      local function fileformat()
        if vim.bo.fileformat == 'unix' then
          return ''
        end

        return icons.os[vim.bo.fileformat]
      end

      local function lsp_clients()
        local active_clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if next(active_clients) == nil then
          return 'LS Inactive'
        end

        local client_names = {}

        for _, client in pairs(active_clients) do
          if client.name ~= 'null-ls' then
            table.insert(client_names, client.name)
          else
            local available_sources = require('null-ls.sources').get_available(vim.bo.filetype)
            local registered = {}
            for _, source in ipairs(available_sources) do
              for method in pairs(source.methods) do
                registered[method] = registered[method] or {}
                table.insert(registered[method], source.name)
              end
            end

            local methods = require('null-ls').methods
            vim.list_extend(client_names, registered[methods.FORMATTING] or {})
            vim.list_extend(client_names, registered[methods.DIAGNOSTICS] or {})
          end
        end

        return table.concat(vim.fn.uniq(client_names), ', ')
      end

      local function lsp_context()
        local value = navic.get_location()
        return icons.ui.breadcrumb .. ' ' .. value:match('^(.*%S)%s*$') .. ' '
      end

      local section_separator = {
        left = icons.powerline.left_half_circle_thick,
        right = icons.powerline.right_half_circle_thick,
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
        },
        extensions = { 'nvim-tree', 'fugitive', 'quickfix', 'toggleterm' },
        sections = {
          lualine_a = {
            {
              'mode',
              separator = section_separator,
            },
          },
          lualine_b = {
            {
              'b:gitsigns_head',
              icon = icons.git.branch,
              fmt = trunc(100, 10, nil, false),
            },
            {
              'diff',
              source = diff_source,
              symbols = map(icons.git.diff, append_whitespace),
              padding = 0,
            },
          },
          lualine_c = {
            {
              'filename',
              file_status = true,
              newfile_status = true,
              color = function()
                return vim.bo.modified and { fg = colors.yellow } or { fg = colors.fg }
              end,
              symbols = icons.file,
              padding = { left = 1 },
            },
            {
              lsp_context,
              cond = navic.is_available,
            },
          },
          lualine_x = {
            {
              lsp_clients,
              icon = icons.ui.gears,
              color = { fg = colors.teal },
              padding = { right = 1 },
            },
            {
              'diagnostics',
              sources = { 'nvim_lsp' },
              symbols = map(icons.lsp, append_whitespace),
              padding = { right = 1 },
            },
            {
              'filetype',
              icon_only = false,
              padding = { right = 1 },
            },
          },
          lualine_y = {
            {
              function()
                return icons.ui.tree
              end,
              color = function()
                local ts = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] or {}
                return { fg = not vim.tbl_isempty(ts) and colors.green or colors.red }
              end,
              padding = { right = 1 },
            },
            { encoding, padding = { right = 1 } },
            { fileformat, padding = { right = 1 } },
          },
          lualine_z = {
            {
              'progress',
              fmt = function()
                return '%P/%L'
              end,
              icon = icons.ui.location,
              padding = { right = 1 },
            },
            {
              'location',
              fmt = function()
                return string.format(
                  '%s%3d %s%3d',
                  icons.powerline.line_number,
                  vim.fn.line('.'),
                  icons.powerline.column_number,
                  vim.fn.virtcol('.')
                )
              end,
              padding = 0,
              separator = section_separator,
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
      })
    end,
  },
}
