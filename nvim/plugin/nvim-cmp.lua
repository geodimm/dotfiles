local luasnip, lspkind, cmp, status_ok
status_ok, luasnip = pcall(require, 'luasnip')
if not status_ok then
  return
end
status_ok, lspkind = pcall(require, 'lspkind')
if not status_ok then
  return
end
status_ok, cmp = pcall(require, 'cmp')
if not status_ok then
  return
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local select_next_item = function(fallback)
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

local select_prev_item = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

local lspkind_comparator = function(conf)
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

local label_comparator = function(entry1, entry2)
  return entry1.completion_item.label < entry2.completion_item.label
end

cmp.setup({
  enabled = function()
    -- disable completion in comments
    local context = require('cmp.config.context')
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment')
    end
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
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      menu = {
        nvim_lsp = '[LSP]',
        luasnip = '[LuaSnip]',
        buffer = '[Buffer]',
        nvim_lua = '[Lua]',
      },
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
    { name = 'luasnip' },
    { name = 'nvim_lua' },
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

require('cmp_git').setup()
