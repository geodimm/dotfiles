local status_ok, lspinstaller, lspconfig, null_ls, cmp_nvim_lsp
status_ok, lspinstaller = pcall(require, 'nvim-lsp-installer')
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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
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
    scope = 'cursor',
    header = { 'Diagnostics', 'Title' },
  }

  local keymap_opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, keymap_opts)
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, keymap_opts)
  vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, keymap_opts)
  vim.keymap.set('n', '<leader>gI', vim.lsp.buf.implementation, keymap_opts)
  vim.keymap.set('n', '<leader>gi', vim.lsp.buf.incoming_calls, keymap_opts)
  vim.keymap.set('n', '<leader>go', vim.lsp.buf.outgoing_calls, keymap_opts)
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, keymap_opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, keymap_opts)
  vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, keymap_opts)
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, keymap_opts)
  vim.keymap.set('n', '<leader>ce', function()
    diagnostics.set(bufnr, true)
    vim.diagnostic.enable(bufnr)
  end, keymap_opts)
  vim.keymap.set('n', '<leader>cd', function()
    diagnostics.set(bufnr, false)
    vim.diagnostic.disable(bufnr)
  end, keymap_opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, keymap_opts)
  vim.keymap.set('v', '<leader>ca', vim.lsp.buf.range_code_action, keymap_opts)
  vim.keymap.set('n', '[d', function()
    if diagnostics.is_disabled(bufnr) then
      return
    end
    vim.diagnostic.goto_prev({ float = diagnostic_float_opts })
  end, keymap_opts)
  vim.keymap.set('n', ']d', function()
    if diagnostics.is_disabled(bufnr) then
      return
    end
    vim.diagnostic.goto_next({ float = diagnostic_float_opts })
  end, keymap_opts)
  vim.keymap.set('n', '<leader>cs', function()
    if diagnostics.is_disabled(bufnr) then
      return
    end
    vim.diagnostic.open_float(nil, vim.tbl_extend('force', diagnostic_float_opts, { scope = 'line' }))
  end, keymap_opts)
  vim.keymap.set('n', '<leader>cl', vim.diagnostic.setloclist, keymap_opts)
  vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, keymap_opts)

  require('utils.whichkey').register({
    mappings = {
      K = 'Documentation',
      ['<leader>g'] = {
        name = '+goto',
        D = 'Declaration',
        I = 'Implementation',
        d = 'Definition',
        i = 'Incoming calls',
        o = 'Outgoing calls',
        r = 'References',
        t = 'Type definition',
      },
      ['<leader>c'] = {
        name = '+lsp',
        a = 'Code actions',
        d = 'Disable diagnostics',
        e = 'Enable diagnostics',
        f = 'Format',
        l = 'Populate location list',
        r = 'Rename',
        s = 'Show diagnostics',
      },
      ['<leader>k'] = 'Signature help',
      [']d'] = { 'Next diagnostic' },
      ['[d'] = { 'Previous diagnostic' },
    },
    opts = { buffer = bufnr },
  }, {
    mappings = {
      ['<leader>c'] = {
        name = '+lsp',
        a = 'Code actions',
      },
    },
    opts = { mode = 'v', buffer = bufnr },
  })

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
    vim.api.nvim_clear_autocmds({
      group = 'lsp_document_highlight',
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  vim.api.nvim_create_augroup('lsp_document_format', { clear = false })
  vim.api.nvim_clear_autocmds({
    group = 'lsp_document_format',
    buffer = bufnr,
  })
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = 'lsp_document_format',
      buffer = bufnr,
      callback = function(_)
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end

  -- Workaround for gopls not organizing imports on vim.lsp.buf.format
  -- Call he organizeImports codeActions for *.go files
  local wait_ms = 3000
  local null_ls_command_prefix = 'NULL_LS'
  local encoding = client.offset_encoding
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'lsp_document_format',
    pattern = { '*.go' },
    callback = function(_)
      local params = vim.lsp.util.make_range_params()
      params.context = { only = { 'source.organizeImports' } }
      local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, wait_ms)
      for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            vim.lsp.util.apply_workspace_edit(r.edit, encoding)
          elseif r.command:sub(1, #null_ls_command_prefix) ~= null_ls_command_prefix then
            vim.lsp.buf.execute_command(r.command)
          end
        end
      end
    end,
  })
end

-- Define LSP configuration settings for languages
local build_lsp_config = {
  gopls = function()
    return {
      cmd = { vim.fn.expand('$HOME/go/bin/gopls', nil, nil), '-remote=auto' },
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
    local ok, lua_dev = pcall(require, 'lua-dev')
    if not ok then
      vim.notify("Cannot import 'lua-dev'. Using empty config", vim.log.levels.WARN)
      return {}
    end
    local config = lua_dev.setup({
      lspconfig = {
        format = { enable = false },
      },
    })
    return config
  end,
  jdtls = function()
    local jdtls_home = vim.fn.expand('$HOME/.local/share/nvim/lsp_servers/jdtls/')
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    return {
      cmd_env = {
        JAVA_HOME = '/usr/lib/jvm/java-11-openjdk-amd64',
        GRADLE_HOME = vim.fn.expand('$HOME/gradle', nil, nil),
        JDTLS_HOME = jdtls_home,
        WORKSPACE = vim.fn.expand('$HOME/java/workspace/') .. project_name,
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
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' },
  }

  local opts = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  if build_lsp_config[server.name] then
    opts = vim.tbl_deep_extend('force', opts, build_lsp_config[server.name]())
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
  lspinstaller.setup({
    ensure_installed = required_servers,
    ui = {
      border = 'rounded',
      icons = {
        server_installed = '✓',
        server_pending = '➜',
        server_uninstalled = '✗',
      },
    },
  })

  -- Run all servers using lspconfig
  for _, server in ipairs(lspinstaller.get_installed_servers()) do
    local config = create_config(server)
    lspconfig[server.name].setup(config)
  end

  -- Configure null-ls with the same on_attach function
  null_ls.setup({
    debug = true,
    diagnostics_format = '#{m} (#{s})',
    on_attach = on_attach,
    sources = {
      -- diagnostics
      null_ls.builtins.diagnostics.golangci_lint.with({
        extra_args = { '--config', vim.fn.expand('$HOME/dotfiles/golangci-lint/golangci.yml', nil, nil) },
      }),
      null_ls.builtins.diagnostics.hadolint,
      null_ls.builtins.diagnostics.jsonlint,
      null_ls.builtins.diagnostics.markdownlint.with({
        extra_args = {
          '--config',
          vim.fn.expand('$HOME/dotfiles/markdownlint/markdownlint.yaml', nil, nil),
        },
      }),
      null_ls.builtins.diagnostics.shellcheck,

      -- formatting
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.jq,
      null_ls.builtins.formatting.shfmt,
      null_ls.builtins.formatting.markdownlint.with({
        extra_args = {
          '--config',
          vim.fn.expand('$HOME/dotfiles/markdownlint/markdownlint.yaml', nil, nil),
        },
      }),

      -- completion
      null_ls.builtins.completion.luasnip,

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
  local icons = require('config.icons').lspconfig
  -- Update the sign icons
  for type, icon in pairs(icons) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Set borders to floating windows
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
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

setup_vim_diagnostics()
setup_servers()
customise_ui()
