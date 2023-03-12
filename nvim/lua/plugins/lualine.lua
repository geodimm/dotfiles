return {
  {
    'hoob3rt/lualine.nvim',
    config = function()
      local lualine = require('lualine')
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

      local function lsp_progress()
        local stage = 0
        local active_clients = vim.lsp.get_active_clients({ bufnr = 0 })
        for _, client in pairs(active_clients) do
          if client.name ~= 'null-ls' then
            local data = client.messages
            stage = #data.progress and 10 or 0
            for _, ctx in pairs(data.progress) do
              local current_stage = ctx.done and 10 or math.floor(ctx.percentage / 10)
              stage = math.min(current_stage, stage)
            end
            break
          end
        end

        return append_whitespace(icons.lsp_progress['stage' .. stage])
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

        return lsp_progress() .. table.concat(vim.fn.uniq(client_names), ', ')
      end

      local function lsp_context()
        if not package.loaded['nvim-navic'] then
          return ''
        end

        local value = require('nvim-navic').get_location()
        return icons.ui.breadcrumb .. ' ' .. value:match('^(.*%S)%s*$') .. ' '
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
              padding = 0,
            },
          },
          lualine_b = {},
          lualine_c = {
            space,
            {
              package.loaded.gitsigns and 'b:gitsigns_head' or 'branch',
              fmt = trunc(100, 10, nil, false),
              icon = icons.git.branch,
              color = { fg = theme.normal.b.fg, bg = theme.normal.b.bg },
              separator = section_separator,
              padding = 0,
            },
            {
              'diff',
              source = package.loaded.gitsigns and diff_source or nil,
              symbols = map(icons.git.diff, append_whitespace),
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
                local c = {}
                if vim.bo.modified then
                  c.fg = colors.yellow
                end
                return c
              end,
              separator = section_separator,
              padding = { left = 1 },
            },
            {
              lsp_context,
              cond = package.loaded['nvim-navic'] and require('nvim-navic').is_available,
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
                return append_whitespace(icons.ui.tree)
              end,
              color = function()
                local ts = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] or {}
                return {
                  fg = not vim.tbl_isempty(ts) and colors.green or colors.red,
                  bg = theme.normal.b.bg,
                }
              end,
              separator = section_separator,
              padding = 0,
            },
            {
              lsp_clients,
              color = { fg = theme.normal.b.fg, bg = theme.normal.b.bg },
              separator = section_separator,
              padding = 0,
            },
            {
              'diagnostics',
              sources = { 'nvim_lsp' },
              symbols = map(icons.lsp, append_whitespace),
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
      })
    end,
  },
}
