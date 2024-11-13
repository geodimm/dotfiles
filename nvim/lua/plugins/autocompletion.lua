return {
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
      local context = require('cmp.config.context')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')
      local cmp_git = require('cmp_git')

      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      local function select_next_item(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end

      local function select_prev_item(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end

      cmp.setup({
        enabled = function()
          local disabled = false
          disabled = disabled or (vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt')
          disabled = disabled or (vim.fn.reg_recording() ~= '')
          disabled = disabled or (vim.fn.reg_executing() ~= '')
          disabled = disabled or context.in_syntax_group('Comment')
          return not disabled
        end,

        preselect = cmp.PreselectMode.None,

        mapping = {
          ['<C-n>'] = cmp.mapping(select_next_item, { 'i', 's' }),
          ['<C-p>'] = cmp.mapping(select_prev_item, { 'i', 's' }),
          ['<Tab>'] = cmp.mapping(select_next_item, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(select_prev_item, { 'i', 's' }),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.close(),
          ['<C-Space>'] = cmp.mapping.complete({}),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        formatting = {
          expandable_indicator = true,
          fields = { cmp.ItemField.Kind, cmp.ItemField.Abbr, cmp.ItemField.Menu },
          format = function(entry, vim_item)
            local kind = lspkind.cmp_format({
              mode = 'symbol_text',
              maxwidth = 50,
              menu = {
                nvim_lsp = '[lsp]',
                luasnip = '[luasnip]',
                buffer = '[buffer]',
                nvim_lua = '[lua]',
              },
            })(entry, vim_item)

            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = ' ' .. strings[1] .. ' '
            local menu = kind.menu
            if #strings > 1 then
              kind.menu = ' ' .. strings[2]
            end
            if menu then
              kind.menu = kind.menu .. ' ' .. menu
            end

            return kind
          end,
        },

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lua' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }, {
          { name = 'path' },
        }),

        window = {
          completion = {
            border = 'rounded',
            winhighlight = 'Search:None',
            side_padding = 0,
          },
          documentation = {
            border = 'rounded',
            winhighlight = 'FloatBorder:Pmenu',
            side_padding = 1,
          },
        },
      })

      require('user.cmp-nvim.gitcommit')
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' },
          { name = 'gitcommit' },
        }, {
          { name = 'buffer' },
        }),
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'cmdline' },
        }, {
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
      })

      cmp_git.setup()

      local function customise_cmp_colors()
        local lsp_types = require('cmp.types').lsp
        for kind, _ in pairs(lsp_types.CompletionItemKind) do
          if type(kind) == 'string' then
            local name = ('CmpItemKind%s'):format(kind)
            local hlinfo = vim.api.nvim_get_hl(0, { name = name })
            if hlinfo then
              vim.api.nvim_set_hl(0, name, { fg = hlinfo.fg, reverse = true })
            end
          end
        end

        local fg = vim.api.nvim_get_hl(0, { name = 'Label' }).fg
        vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = fg })
      end

      vim.api.nvim_create_augroup('user_customise_cmp_colors', { clear = true })
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = 'user_customise_cmp_colors',
        desc = 'customise the CmpItemKind colors',
        pattern = '*',
        callback = customise_cmp_colors,
      })

      customise_cmp_colors()
    end,
  },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-nvim-lua' },
  {
    'petertriho/cmp-git',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
    dependencies = { 'rafamadriz/friendly-snippets' },
    build = 'make install_jsregexp',
  },
  {
    'saadparwaiz1/cmp_luasnip',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
    },
  },
  { 'onsails/lspkind-nvim' },
}
