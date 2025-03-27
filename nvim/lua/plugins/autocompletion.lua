return {
  {
    'saghen/blink.cmp',
    lazy = false,
    dependencies = {
      'rafamadriz/friendly-snippets',
      'xzbdmw/colorful-menu.nvim',
      'catppuccin/nvim', -- to customise highlights
    },
    version = 'v1.*',
    config = function()
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      local opts = {
        keymap = {
          preset = 'enter',
          ['<Tab>'] = {
            function(cmp)
              if cmp.is_visible() then
                return cmp.select_next()
              elseif cmp.snippet_active() then
                return cmp.snippet_forward()
              elseif has_words_before() then
                return cmp.show()
              end
            end,
            'fallback',
          },
          ['<S-Tab>'] = {
            function(cmp)
              if cmp.is_visible() then
                return cmp.select_prev()
              elseif cmp.snippet_active() then
                return cmp.snippet_backward()
              elseif has_words_before() then
                return cmp.show()
              end
            end,
            'fallback',
          },
        },

        enabled = function()
          local disabled = false
          disabled = disabled or vim.bo.buftype == 'prompt'
          disabled = disabled or vim.bo.filetype == 'snacks_input'
          disabled = disabled or (vim.fn.reg_recording() ~= '')
          disabled = disabled or (vim.fn.reg_executing() ~= '')
          return not disabled
        end,

        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = 'normal',
        },

        completion = {
          list = {
            selection = {
              preselect = false,
            },
          },
          menu = {
            border = 'rounded',
            draw = {
              treesitter = { 'lsp' },
              -- We don't need label_description now because label and label_description are already
              -- combined together in label by colorful-menu.nvim.
              columns = { { 'kind_icon' }, { 'label', gap = 1 }, { 'kind' }, { 'source_name' } },
              components = {
                label = {
                  text = function(ctx)
                    return require('colorful-menu').blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require('colorful-menu').blink_components_highlight(ctx)
                  end,
                },
                kind_icon = {
                  ellipsis = false,
                  text = function(ctx)
                    return ctx.icon_gap .. ctx.kind_icon .. ctx.icon_gap
                  end,
                  highlight = function(ctx)
                    return 'BlinkCmpKind' .. ctx.kind .. 'Reversed'
                  end,
                },
              },
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,
            window = {
              border = 'rounded',
            },
          },
          ghost_text = {
            enabled = true,
          },
        },

        signature = {
          enabled = false,
          window = {
            border = 'rounded',
          },
        },

        sources = {
          default = function(ctx)
            if vim.bo.filetype == 'lua' then
              return { 'lsp', 'lazydev', 'path', 'snippets', 'buffer' }
            end

            local success, node = pcall(vim.treesitter.get_node)
            if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
              return { 'buffer' }
            end

            return { 'lsp', 'path', 'snippets', 'buffer' }
          end,
          providers = {
            lazydev = {
              name = 'lazydev',
              module = 'lazydev.integrations.blink',
              fallbacks = { 'lsp' },
            },
          },
        },
        cmdline = {
          keymap = {
            preset = 'cmdline',
          },
          completion = {
            list = {
              selection = {
                preselect = false,
              },
            },
            menu = {
              auto_show = function(ctx)
                return vim.fn.getcmdtype() == ':'
              end,
              draw = {
                columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
              },
            },
          },
        },
      }

      require('blink.cmp').setup(opts)

      for _, kind in ipairs(require('blink.cmp.types').CompletionItemKind) do
        local name = 'BlinkCmpKind' .. kind
        local hlinfo = vim.api.nvim_get_hl(0, { name = name })
        if hlinfo then
          vim.api.nvim_set_hl(0, name .. 'Reversed', { fg = hlinfo.fg, reverse = true })
        end

        -- related PR: https://github.com/catppuccin/nvim/pull/809
        for _, hl in ipairs({ 'BlinkCmpMenuBorder', 'BlinkCmpDocBorder', 'BlinkCmpSignatureHelpBorder' }) do
          vim.api.nvim_set_hl(0, hl, { link = 'FloatBorder' })
        end
      end
    end,
  },
  {
    'xzbdmw/colorful-menu.nvim',
    opts = {},
  },
}
