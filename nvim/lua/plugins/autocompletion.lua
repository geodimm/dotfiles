return {
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
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

      local function lspkind_comparator(conf)
        local lsp_types = require('cmp.types').lsp
        return function(entry1, entry2)
          if entry1.source.name ~= 'nvim_lsp' then
            if entry2.source.name == 'nvim_lsp' then
              return false
            else
              return nil
            end
          end
          local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
          local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

          local priority1 = conf.kind_priority[kind1] or 0
          local priority2 = conf.kind_priority[kind2] or 0
          if priority1 == priority2 then
            return nil
          end
          return priority2 < priority1
        end
      end

      local function label_comparator(entry1, entry2)
        return entry1.completion_item.label < entry2.completion_item.label
      end

      cmp.setup({
        window = {
          completion = {
            border = 'rounded',
            winhighlight = 'CursorLine:Visual,Search:None',
            zindex = 1001,
            col_offset = -3,
            side_padding = 0,
          },
          documentation = {
            border = 'rounded',
            winhighlight = 'CursorLine:Visual,Search:None',
            zindex = 1001,
            col_offset = 10,
            side_padding = 1,
          },
        },
        formatting = {
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
            kind.menu = ' ' .. strings[2]
            if menu then
              kind.menu = kind.menu .. ' ' .. menu
            end

            return kind
          end,
        },
        enabled = function()
          -- disable completion in prompts such as telescope filtering prompt
          local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
          if buftype == 'prompt' then
            return false
          end

          -- disable completion in comments
          local context = require('cmp.config.context')
          if context.in_syntax_group('Comment') then
            return false
          end

          return true
        end,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
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
        sorting = {
          comparators = {
            lspkind_comparator({
              kind_priority = {
                Variable = 12,
                Field = 11,
                Property = 11,
                Constant = 10,
                Enum = 10,
                EnumMember = 10,
                Event = 10,
                Function = 10,
                Method = 10,
                Operator = 10,
                Reference = 10,
                Struct = 10,
                Module = 9,
                File = 8,
                Folder = 8,
                Class = 5,
                Color = 5,
                Keyword = 2,
                Constructor = 1,
                Interface = 1,
                Text = 1,
                TypeParameter = 1,
                Unit = 1,
                Value = 1,
                Snippet = 0,
              },
            }),
            label_comparator,
          },
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
      })

      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' },
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
            local ok, hlgroup = pcall(vim.api.nvim_get_hl_by_name, name, true)
            if ok then
              hlgroup.reverse = true
              vim.api.nvim_set_hl(0, name, hlgroup)
            end
          end
        end

        local fg = vim.api.nvim_get_hl_by_name('Label', true).foreground
        vim.api.nvim_set_hl(0, 'CmpItemMenu', { foreground = fg })
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
  },
  {
    'saadparwaiz1/cmp_luasnip',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
    },
  },
  { 'rafamadriz/friendly-snippets' },
  { 'onsails/lspkind-nvim' },
}
