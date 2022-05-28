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
      select = true,
    }),
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
    }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  }),
})

require('cmp_git').setup()
