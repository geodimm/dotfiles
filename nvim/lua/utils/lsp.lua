local M = {}

local feat = require('utils.feat')
local icons = require('user.icons')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, bufnr)
  -- Set formatting to enabled by default
  feat.Formatting:set(bufnr, true)

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
  keymap.set('n', '<leader>ck', vim.lsp.buf.signature_help, { desc = 'Signature help', buffer = bufnr })
  keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { desc = 'Signature help', buffer = bufnr })
  keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename', buffer = bufnr })
  keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { desc = 'Run codelens', buffer = bufnr })

  -- Diagnostics
  keymap.set('n', '<leader>cs', function()
    vim.diagnostic.open_float({
      focusable = false,
      close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter' },
      border = 'rounded',
      source = true,
      prefix = function(_, i, total)
        if total > 1 then
          return tostring(i) .. '. ', ''
        end

        return '', ''
      end,
      scope = 'line',
    })
  end, { desc = 'Show all diagnostics for current line', buffer = bufnr })

  keymap.register_group('<leader>g', 'Goto', { icon = icons.ui.code_braces }, { buffer = bufnr })
  keymap.register_group('<leader>c', 'LSP', { mode = { 'n', 'v' }, icon = icons.ui.code_braces }, { buffer = bufnr })

  if client.server_capabilities.documentHighlightProvider then
    local lsp_hl_augroup = vim.api.nvim_create_augroup('user_lsp_document_highlight', { clear = false })
    vim.api.nvim_clear_autocmds({
      group = lsp_hl_augroup,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = lsp_hl_augroup,
      buffer = bufnr,
      desc = 'highlight current symbol on hover',
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = lsp_hl_augroup,
      buffer = bufnr,
      desc = 'clear current symbol highlight',
      callback = vim.lsp.buf.clear_references,
    })
  end

  vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('user_lsp_refresh_codelens', { clear = true }),
    desc = 'refresh lsp codelens',
    callback = function()
      vim.lsp.codelens.refresh({ bufnr = bufnr })
    end,
  })

  -- Don't attach yamlls to helm files
  if client.name == 'yamlls' and vim.bo.filetype == 'helm' then
    vim.schedule(function()
      vim.lsp.buf_detach_client(bufnr, client.id)
    end)
  end
end

-- Create config that sets up LSP keymaps, augroups and capabilities
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

M.on_attach = on_attach
M.create_config = create_config

return M
