local M = {}

local feat = require('utils.feat')
local icons = require('user.icons').lspconfig

local function configure_keymaps(bufnr)
  -- Set formatting to enabled by default
  feat.Formatting:set(bufnr, true)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

  local diagnostic_float_opts = {
    focusable = false,
    close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter' },
    border = 'rounded',
    source = 'always',
    prefix = function(_, i, total)
      if total > 1 then
        return tostring(i) .. '. '
      end

      return ''
    end,
    format = function(diagnostic)
      if diagnostic.code then
        return string.format('%s [%s]', diagnostic.message, diagnostic.code)
      end

      return diagnostic.message
    end,
    scope = 'cursor',
    header = { 'Diagnostics', 'Title' },
  }

  local keymap = require('utils.keymap')
  local status_ok, fzf = pcall(require, 'fzf-lua')
  if status_ok then
    keymap.set('n', '<leader>gD', fzf.lsp_declarations, { desc = 'Declaration', buffer = bufnr })
    keymap.set('n', '<leader>gd', function()
      fzf.lsp_definitions({ jump1 = true })
    end, { desc = 'Definition', buffer = bufnr })
    keymap.set('n', '<leader>gt', fzf.lsp_typedefs, { desc = 'Type definition', buffer = bufnr })
    keymap.set('n', '<leader>gI', fzf.lsp_implementations, { desc = 'Implementation', buffer = bufnr })
    keymap.set('n', '<leader>gi', fzf.lsp_incoming_calls, { desc = 'Incoming calls', buffer = bufnr })
    keymap.set('n', '<leader>go', fzf.lsp_outgoing_calls, { desc = 'Outgoing calls', buffer = bufnr })
    keymap.set('n', '<leader>gr', fzf.lsp_references, { desc = 'References', buffer = bufnr })
    keymap.set('n', '<leader>gs', fzf.lsp_document_symbols, { desc = 'Document symbols', buffer = bufnr })
    keymap.set('n', '<leader>gw', fzf.lsp_workspace_symbols, { desc = 'Workspace symbols', buffer = bufnr })
    keymap.set({ 'v', 'n' }, '<leader>ca', fzf.lsp_code_actions, { desc = 'Code action', buffer = bufnr })
  else
    keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, { desc = 'Declaration', buffer = bufnr })
    keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { desc = 'Definition', buffer = bufnr })
    keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, { desc = 'Type definition', buffer = bufnr })
    keymap.set('n', '<leader>gI', vim.lsp.buf.implementation, { desc = 'Implementation', buffer = bufnr })
    keymap.set('n', '<leader>gi', vim.lsp.buf.incoming_calls, { desc = 'Incoming calls', buffer = bufnr })
    keymap.set('n', '<leader>go', vim.lsp.buf.outgoing_calls, { desc = 'Outgoing calls', buffer = bufnr })
    keymap.set('n', '<leader>gr', vim.lsp.buf.references, { desc = 'References', buffer = bufnr })
    keymap.set('n', '<leader>gs', vim.lsp.buf.document_symbol, { desc = 'Document symbols', buffer = bufnr })
    keymap.set('n', '<leader>gw', vim.lsp.buf.workspace_symbol, { desc = 'Workspace symbols', buffer = bufnr })
    keymap.set({ 'v', 'n' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action', buffer = bufnr })
  end
  keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Documentation', buffer = bufnr })
  keymap.set('n', '<leader>ck', vim.lsp.buf.signature_help, { desc = 'Signature help', buffer = bufnr })
  keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { desc = 'Signature help', buffer = bufnr })
  keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename', buffer = bufnr })
  keymap.set('n', '<leader>cu', vim.lsp.codelens.refresh, { desc = 'Refresh codelens', buffer = bufnr })
  keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { desc = 'Run codelens', buffer = bufnr })

  -- Diagnostics
  keymap.set('n', '[d', function()
    vim.diagnostic.goto_prev({ float = diagnostic_float_opts })
  end, { desc = 'Go to previous diagnostic', buffer = bufnr })
  keymap.set('n', ']d', function()
    vim.diagnostic.goto_next({ float = diagnostic_float_opts })
  end, { desc = 'Go to next diagnostic', buffer = bufnr })
  keymap.set('n', '<leader>cs', function()
    vim.diagnostic.open_float(nil, vim.tbl_extend('force', diagnostic_float_opts, { scope = 'line' }))
  end, { desc = 'Show diagnostics', buffer = bufnr })

  keymap.register_group('<leader>g', 'Goto', { buffer = bufnr })
  keymap.register_group('<leader>c', 'LSP', { buffer = bufnr, mode = { 'n', 'v' } })
end

local function configure_autocmds(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup('user_lsp_document_highlight', { clear = false })
    vim.api.nvim_clear_autocmds({
      group = 'user_lsp_document_highlight',
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = 'user_lsp_document_highlight',
      buffer = bufnr,
      desc = 'highlight current symbol on hover',
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'user_lsp_document_highlight',
      buffer = bufnr,
      desc = 'clear current symbol highlight',
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, bufnr)
  configure_keymaps(bufnr)
  configure_autocmds(client, bufnr)

  -- As of v0.11.0, gopls does not send a Semantic Token legend (in a
  -- client/registerCapability message) unless the client supports dynamic
  -- registration. Neovim's LSP client does not support dynamic registration
  -- for semantic tokens, so we need to declare those server_capabilities
  -- ourselves for the time being.
  -- Ref. https://github.com/golang/go/issues/54531
  if client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
    local semantic = client.config.capabilities.textDocument.semanticTokens
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = {
        tokenModifiers = semantic.tokenModifiers,
        tokenTypes = semantic.tokenTypes,
      },
      range = true,
    }
  end

  -- Don't attach yamlls to helm files
  if client.name == 'yamlls' and vim.bo.filetype == 'helm' then
    vim.schedule(function()
      vim.lsp.buf_detach_client(bufnr, client.id)
    end)
  end

  if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
  end
end

-- Create config that activates keymaps and enables snippet support
local function create_config(servers, server)
  local capabilities = vim.tbl_extend(
    'force',
    require('blink.cmp').get_lsp_capabilities(),
    require('lsp-file-operations').default_capabilities()
  )

  local opts = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  if servers[server] then
    opts = vim.tbl_deep_extend('force', opts, servers[server]())
  end

  return opts
end

local function customise_ui()
  -- Update the sign icons
  for type, icon in pairs(icons) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Update LspInfo window border
  require('lspconfig.ui.windows').default_options.border = 'rounded'
end

local function setup_vim_diagnostics()
  vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = true,
    float = {
      border = 'rounded',
    },
    update_in_insert = true,
    severity_sort = true,
  })
end

M.on_attach = on_attach
M.create_config = create_config
M.customise_ui = customise_ui
M.setup_vim_diagnostics = setup_vim_diagnostics

return M
