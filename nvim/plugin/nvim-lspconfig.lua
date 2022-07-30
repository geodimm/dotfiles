local status_ok, lspinstaller, lspconfig, cmp_nvim_lsp
status_ok, lspinstaller = pcall(require, 'nvim-lsp-installer')
if not status_ok then
  return
end
status_ok, lspconfig = pcall(require, 'lspconfig')
if not status_ok then
  return
end
status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
  return
end

-- diagnostics is map[number]bool which keeps the current status of
-- lsp diagnostics for each buffer.
local diagnostics = {}

-- set_diagnostics updates the status of lsp diagnostics for a buffer
local set_diagnostics = function(bufnr, enabled)
  diagnostics[bufnr] = enabled
end

-- diagnostics_disabled returns whether lsp diagnostics are disabled for a buffer
local diagnostics_disabled = function(bufnr)
  return not diagnostics[bufnr]
end

local null_ls_command_prefix = 'NULL_LS'

local org_imports = function(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { 'source.organizeImports' } }
  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, 'utf-16')
      elseif r.command:sub(1, #null_ls_command_prefix) ~= null_ls_command_prefix then
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

vim.api.nvim_create_augroup('lsp_formatting', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'lsp_formatting',
  pattern = {
    '*.c',
    '*.h',
    '*.go',
    '*.lua',
    '*.tf',
    '*.sh',
    '*.bash',
    '*.js',
    '*.yaml',
    '*.yml',
    '*.json',
    '*.html',
    '*.md',
  },
  callback = function(args)
    vim.lsp.buf.format()
    local goSuffix = '.go'
    if args.match:sub(-string.len(goSuffix)) == goSuffix then
      org_imports(3000)
    end
  end,
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mark diagnostics as enabled by default
  set_diagnostics(bufnr)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
    set_diagnostics(bufnr, true)
    vim.diagnostic.enable(bufnr)
  end, keymap_opts)
  vim.keymap.set('n', '<leader>cd', function()
    set_diagnostics(bufnr, false)
    vim.diagnostic.disable(bufnr)
  end, keymap_opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, keymap_opts)
  vim.keymap.set('v', '<leader>ca', vim.lsp.buf.range_code_action, keymap_opts)
  vim.keymap.set('n', '[d', function()
    vim.diagnostic.goto_prev({ float = false })
  end, keymap_opts)
  vim.keymap.set('n', ']d', function()
    vim.diagnostic.goto_next({ float = false })
  end, keymap_opts)
  vim.keymap.set('n', '<leader>cl', vim.diagnostic.setloclist, keymap_opts)

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

  -- Diagnostics for specific cursor position
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
      if diagnostics_disabled(bufnr) then
        return
      end

      local diagnostic_float_opts = {
        focusable = false,
        close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter' },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, diagnostic_float_opts)
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
    return {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          completion = { callSnippet = 'Both' },
          diagnostics = { globals = { 'vim' } },
          workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
          format = { enable = false },
        },
      },
    }
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

-- Configure nvim-lsp-installer and lspconfig
local setup_servers = function()
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

  for _, server in ipairs(lspinstaller.get_installed_servers()) do
    local config = create_config(server)
    lspconfig[server.name].setup(config)
  end
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
