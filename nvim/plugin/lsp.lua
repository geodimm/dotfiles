local status_ok, mason, mason_lspconfig, lspconfig, null_ls, cmp_nvim_lsp
status_ok, mason = pcall(require, 'mason')
if not status_ok then
  return
end
status_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not status_ok then
  return
end
status_ok, lspconfig = pcall(require, 'lspconfig')
if not status_ok then
  return
end
status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
  return
end
status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
  return
end

local diagnostics = require('utils.diagnostics')

local configure_keymaps = function(bufnr)
  -- Mark diagnostics as enabled by default
  diagnostics.set(bufnr, true)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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

  local keymaps = require('user.keymaps')
  keymaps.set('n', '<leader>gD', vim.lsp.buf.declaration, { desc = 'Declaration', buffer = bufnr })
  keymaps.set('n', '<leader>gd', vim.lsp.buf.definition, { desc = 'Definition', buffer = bufnr })
  keymaps.set('n', '<leader>gt', vim.lsp.buf.type_definition, { desc = 'Type definition', buffer = bufnr })
  keymaps.set('n', '<leader>gI', vim.lsp.buf.implementation, { desc = 'Implementation', buffer = bufnr })
  keymaps.set('n', '<leader>gi', vim.lsp.buf.incoming_calls, { desc = 'Incoming calls', buffer = bufnr })
  keymaps.set('n', '<leader>go', vim.lsp.buf.outgoing_calls, { desc = 'Outgoing calls', buffer = bufnr })
  keymaps.set('n', '<leader>gr', vim.lsp.buf.references, { desc = 'References', buffer = bufnr })
  keymaps.set('n', 'K', vim.lsp.buf.hover, { desc = 'Documentation', buffer = bufnr })
  keymaps.set('n', '<leader>ck', vim.lsp.buf.signature_help, { desc = 'Signature help', buffer = bufnr })
  keymaps.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename', buffer = bufnr })
  keymaps.set('n', '<leader>ce', function()
    diagnostics.set(bufnr, true)
    vim.diagnostic.enable(bufnr)
  end, { desc = 'Enable diagnostics', buffer = bufnr })
  keymaps.set('n', '<leader>cd', function()
    diagnostics.set(bufnr, false)
    vim.diagnostic.disable(bufnr)
  end, { desc = 'Disable diagnostics', buffer = bufnr })
  keymaps.set({ 'v', 'n' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action', buffer = bufnr })
  keymaps.set('n', '[d', function()
    if diagnostics.is_disabled(bufnr) then
      return
    end
    vim.diagnostic.goto_prev({ float = diagnostic_float_opts })
  end, { desc = 'Go to previous diagnostic', buffer = bufnr })
  keymaps.set('n', ']d', function()
    if diagnostics.is_disabled(bufnr) then
      return
    end
    vim.diagnostic.goto_next({ float = diagnostic_float_opts })
  end, { desc = 'Go to next diagnostic', buffer = bufnr })
  keymaps.set('n', '<leader>cs', function()
    if diagnostics.is_disabled(bufnr) then
      return
    end
    vim.diagnostic.open_float(nil, vim.tbl_extend('force', diagnostic_float_opts, { scope = 'line' }))
  end, { desc = 'Show diagnostics', buffer = bufnr })
  keymaps.set('n', '<leader>cl', vim.diagnostic.setloclist, { desc = 'Populate loclist', buffer = bufnr })
  keymaps.set('n', '<leader>cf', vim.lsp.buf.format, { desc = 'Format', buffer = bufnr })

  keymaps.register_group('<leader>g', 'Goto', { buffer = bufnr })
  keymaps.register_group('<leader>c', 'LSP', { buffer = bufnr })
  keymaps.register_group('<leader>c', 'LSP', { buffer = bufnr, mode = 'v' })
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

  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_augroup('user_lsp_document_format', { clear = false })
    vim.api.nvim_clear_autocmds({
      group = 'user_lsp_document_format',
      buffer = bufnr,
    })
    local null_ls_command_prefix = 'NULL_LS'
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = 'user_lsp_document_format',
      buffer = bufnr,
      desc = 'format on save',
      callback = function(_)
        vim.lsp.buf.format({ bufnr = bufnr })

        -- Workaround for gopls not organizing imports on vim.lsp.buf.format
        -- Call the organizeImports codeActions for *.go files
        if vim.bo.filetype == 'go' then
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { 'source.organizeImports' } }
          local result = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params, 3000)
          for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
              elseif r.command:sub(1, #null_ls_command_prefix) ~= null_ls_command_prefix then
                vim.lsp.buf.execute_command(r.command)
              end
            end
          end
        end
      end,
    })
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  configure_keymaps(bufnr)
  configure_autocmds(client, bufnr)
end

-- Define LSP configuration settings for languages
local build_lsp_config = {
  gopls = function()
    return {
      settings = {
        gopls = {
          buildFlags = { '-tags=all,test_setup' },
          codelenses = {
            tidy = true,
            vendor = true,
            generate = true,
            regenerate_cgo = true,
            upgrade_dependency = true,
            gc_details = true,
            test = true,
          },
          analyses = {
            ST1003 = false,
            undeclaredname = true,
            unusedparams = true,
            fillreturns = true,
            nonewvars = true,
            fieldalignment = false,
            shadow = true,
            useany = true,
            nilness = true,
            unusedwrite = true,
          },
          gofumpt = true,
          staticcheck = true,
          importShortcut = 'Both',
          completionDocumentation = true,
          linksInHover = true,
          usePlaceholders = true,
          experimentalPostfixCompletions = true,
          hoverKind = 'FullDocumentation',
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
        tags = { skipUnexported = true },
      },
    }
  end,
  sumneko_lua = function()
    local ok, neodev = pcall(require, 'neodev')
    if not ok then
      vim.notify("Cannot import 'neodev'. Using empty config", vim.log.levels.WARN)
      return {}
    end

    neodev.setup({})

    return {
      lspconfig = {
        settings = {
          Lua = {
            format = { enable = false },
          },
        },
      },
    }
  end,
  jdtls = function()
    local workspace_dir = vim.fn.expand('$HOME/java/workspace/')
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    return {
      init_options = {
        workspace = workspace_dir .. project_name,
      },
      settings = {
        java = {},
      },
    }
  end,
  yamlls = function()
    return {
      settings = {
        yaml = {
          hover = true,
          completion = true,
          format = { enable = true },
          validate = true,
          schemas = {
            ['https://json.schemastore.org/golangci-lint.json'] = '*golangci.y*ml',
            ['https://json.schemastore.org/kustomization.json'] = '/*kustomization.y*ml',
            ['https://json.schemastore.org/swagger-2.0.json'] = '/*swagger.y*ml',
            ['https://json.schemastore.org/travis.json'] = '/*travis.y*ml',
            ['https://json.schemastore.org/yamllint.json'] = '/*yamllint.y*ml',
            ['https://json.schemastore.org/markdownlint.json'] = '/*.markdownlint.y*ml',
            ['https://raw.githubusercontent.com/GoogleContainerTools/skaffold/master/docs/content/en/schemas/v2beta12.json'] = '/*skaffold.y*ml',
          },
          schemaStore = {
            url = 'https://www.schemastore.org/json',
            enable = true,
          },
        },
      },
    }
  end,
  jsonls = function()
    return { settings = { json = { format = { enable = true } } } }
  end,
}

-- Create config that activates keymaps and enables snippet support
local create_config = function(server)
  local capabilities = cmp_nvim_lsp.default_capabilities()

  local opts = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  if build_lsp_config[server] then
    opts = vim.tbl_deep_extend('force', opts, build_lsp_config[server]())
  end

  return opts
end

-- Configure nvim-lsp-installer lspconfig, and null-ls
local setup_servers = function()
  -- ensure all required LSP servers are installed
  local required_servers = {
    'gopls',
    'sumneko_lua',
    'bashls',
    'jsonls',
    'yamlls',
    'dockerls',
    'html',
    'terraformls',
    'pyright',
    'jdtls',
    'denols',
  }
  mason.setup({
    ui = {
      border = 'rounded',
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
    },
  })
  mason_lspconfig.setup({
    ensure_installed = required_servers,
  })

  -- Run all servers using lspconfig
  for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
    local config = create_config(server)
    lspconfig[server].setup(config)
  end

  -- Configure null-ls with the same on_attach function
  null_ls.setup({
    debug = false,
    diagnostics_format = '#{m}',
    on_attach = on_attach,
    sources = {
      -- diagnostics
      null_ls.builtins.diagnostics.golangci_lint.with({
        extra_args = { '--config', vim.fn.expand('$HOME/dotfiles/golangci-lint/golangci.yml') },
      }),
      null_ls.builtins.diagnostics.hadolint,
      null_ls.builtins.diagnostics.jsonlint,
      null_ls.builtins.diagnostics.markdownlint.with({
        extra_args = {
          '--config',
          vim.fn.expand('$HOME/dotfiles/markdownlint/markdownlint.yaml'),
        },
      }),
      null_ls.builtins.diagnostics.zsh,
      null_ls.builtins.diagnostics.actionlint,

      -- formatting
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.jq,
      null_ls.builtins.formatting.shfmt,
      null_ls.builtins.formatting.markdownlint.with({
        extra_args = {
          '--config',
          vim.fn.expand('$HOME/dotfiles/markdownlint/markdownlint.yaml'),
        },
      }),

      -- code actions
      null_ls.builtins.code_actions.refactoring,
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.code_actions.shellcheck,

      -- hover
      null_ls.builtins.hover.dictionary,
    },
  })
end

local customise_ui = function()
  local icons = require('user.icons').lspconfig
  -- Update the sign icons
  for type, icon in pairs(icons) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Set borders to floating windows
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

  -- Use nvim-notify for LSP messages
  vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
    local timeout = (result.type < 2 and 3000 or 1500)
    vim.notify(result.message, lvl, { title = 'LSP | ' .. client.name, timeout = timeout })
  end

  -- Update LspInfo window border
  require('lspconfig.ui.windows').default_options.border = 'rounded'
end

local setup_vim_diagnostics = function()
  vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = true,
    float = false,
    update_in_insert = true,
    severity_sort = true,
  })
end

customise_ui()
setup_vim_diagnostics()
setup_servers()
