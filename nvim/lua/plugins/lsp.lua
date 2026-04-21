local icons = require('user.icons')
local keymap = require('utils.keymap')

---@param args { buf: integer, data: any }
local function on_attach(args)
  if not args or not args.data then
    return
  end

  ---@type vim.lsp.Client|nil
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then
    return
  end

  local status_ok, fzf = pcall(require, 'fzf-lua')
  if status_ok then
    keymap.set('n', '<leader>gD', fzf.lsp_declarations, { desc = 'Declaration', buffer = args.buf })
    keymap.set('n', '<leader>gd', function()
      fzf.lsp_definitions({ jump1 = true })
    end, { desc = 'Definition', buffer = args.buf })
    keymap.set('n', '<leader>gt', fzf.lsp_typedefs, { desc = 'Type definition', buffer = args.buf })
    keymap.set('n', '<leader>gI', fzf.lsp_implementations, { desc = 'Implementation', buffer = args.buf })
    keymap.set('n', '<leader>gi', fzf.lsp_incoming_calls, { desc = 'Incoming calls', buffer = args.buf })
    keymap.set('n', '<leader>go', fzf.lsp_outgoing_calls, { desc = 'Outgoing calls', buffer = args.buf })
    keymap.set('n', '<leader>gr', fzf.lsp_references, { desc = 'References', buffer = args.buf })
    keymap.set('n', '<leader>gs', fzf.lsp_document_symbols, { desc = 'Document symbols', buffer = args.buf })
    keymap.set('n', '<leader>gw', fzf.lsp_workspace_symbols, { desc = 'Workspace symbols', buffer = args.buf })
    keymap.set({ 'v', 'n' }, '<leader>ca', fzf.lsp_code_actions, { desc = 'Code action', buffer = args.buf })
  else
    keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, { desc = 'Declaration', buffer = args.buf })
    keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { desc = 'Definition', buffer = args.buf })
    keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, { desc = 'Type definition', buffer = args.buf })
    keymap.set('n', '<leader>gI', vim.lsp.buf.implementation, { desc = 'Implementation', buffer = args.buf })
    keymap.set('n', '<leader>gi', vim.lsp.buf.incoming_calls, { desc = 'Incoming calls', buffer = args.buf })
    keymap.set('n', '<leader>go', vim.lsp.buf.outgoing_calls, { desc = 'Outgoing calls', buffer = args.buf })
    keymap.set('n', '<leader>gr', vim.lsp.buf.references, { desc = 'References', buffer = args.buf })
    keymap.set('n', '<leader>gs', vim.lsp.buf.document_symbol, { desc = 'Document symbols', buffer = args.buf })
    keymap.set('n', '<leader>gw', vim.lsp.buf.workspace_symbol, { desc = 'Workspace symbols', buffer = args.buf })
    keymap.set({ 'v', 'n' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action', buffer = args.buf })
  end
  keymap.set('n', '<leader>ck', vim.lsp.buf.signature_help, { desc = 'Signature help', buffer = args.buf })
  keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename', buffer = args.buf })
  keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { desc = 'Run codelens', buffer = args.buf })

  keymap.register_group('<leader>g', 'Goto', { icon = icons.ui.code_braces }, { buffer = args.buf })
  keymap.register_group('<leader>c', 'LSP', { mode = { 'n', 'v' }, icon = icons.ui.code_braces }, { buffer = args.buf })

  if client.server_capabilities.documentHighlightProvider then
    local lsp_hl_augroup = vim.api.nvim_create_augroup('user_lsp_document_highlight', { clear = false })
    vim.api.nvim_clear_autocmds({
      group = lsp_hl_augroup,
      buffer = args.buf,
    })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = lsp_hl_augroup,
      desc = 'highlight current symbol on hover',
      buffer = args.buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = lsp_hl_augroup,
      desc = 'clear current symbol highlight',
      buffer = args.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end

  vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('user_lsp_refresh_codelens', {}),
    desc = 'refresh lsp codelens',
    callback = function()
      vim.lsp.codelens.enable(true)
    end,
  })

  if client.name == 'yamlls' and vim.bo.filetype == 'helm' then
    vim.schedule(function()
      vim.lsp.buf_detach_client(args.buf, client.id)
    end)
  end

  if client:supports_method('textDocument/foldingRange') then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  end
end

local M = {}

function M.setup()
  require('lspconfig.ui.windows').default_options.border = 'rounded'
  vim.diagnostic.config({
    underline = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.lsp.error,
        [vim.diagnostic.severity.WARN] = icons.lsp.warn,
        [vim.diagnostic.severity.INFO] = icons.lsp.info,
        [vim.diagnostic.severity.HINT] = icons.lsp.hint,
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
        [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
        [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
        [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
      },
    },
    float = {
      border = 'rounded',
      source = true,
    },
    jump = {
      float = true,
    },
    update_in_insert = false,
    severity_sort = true,
  })

  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  vim.lsp.log.set_level('OFF')

  local orig_apply_workspace_edit = vim.lsp.util.apply_workspace_edit
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.apply_workspace_edit(workspace_edit, offset_encoding, ...)
    local result = orig_apply_workspace_edit(workspace_edit, offset_encoding, ...)
    vim.schedule(function()
      vim.cmd('silent! wall')
      vim.cmd('checktime')
    end)
    return result
  end

  require('lsp-file-operations').setup({})

  vim.lsp.config('*', {
    capabilities = vim.tbl_extend(
      'force',
      require('blink.cmp').get_lsp_capabilities(),
      require('lsp-file-operations').default_capabilities()
    ),
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user_lsp_attach', {}),
    desc = 'LSP actions',
    callback = on_attach,
  })

  local mason_lspconfig = require('mason-lspconfig')
  local installed_servers = mason_lspconfig.get_installed_servers()
  if vim.fn.executable('tilt') then
    installed_servers = vim.list_extend(installed_servers, { 'tilt_ls' })
  end

  vim.lsp.enable(installed_servers)

  local null_ls = require('null-ls')
  local null_opts = {
    debug = false,
    diagnostics_format = '#{m}',
    on_attach = function(client, bufnr)
      on_attach({
        buf = bufnr,
        data = {
          client_id = client.id,
        },
      })
    end,
    sources = {
      null_ls.builtins.code_actions.refactoring,
      null_ls.builtins.code_actions.gomodifytags,
      null_ls.builtins.hover.dictionary,
    },
  }
  null_ls.setup(null_opts)
end

return M
