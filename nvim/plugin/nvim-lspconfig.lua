local lspinstaller, lspconfig, wk, cmp_nvim_lsp, status_ok
status_ok, lspinstaller = pcall(require, 'nvim-lsp-installer')
if not status_ok then
  return
end
status_ok, lspconfig = pcall(require, 'lspconfig')
if not status_ok then
  return
end
status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end
status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not status_ok then
  return
end

local org_imports = function(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { 'source.organizeImports' } }
  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, 'utf-16')
      else
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
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>gI', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<leader>gi', vim.lsp.buf.incoming_calls, opts)
  vim.keymap.set('n', '<leader>go', vim.lsp.buf.outgoing_calls, opts)
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('v', '<leader>ca', vim.lsp.buf.range_code_action, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>cl', vim.diagnostic.setloclist, opts)

  wk.register({
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
      f = 'Format',
      l = 'Populate location list',
      r = 'Rename',
    },
    ['<leader>k'] = 'Signature help',
    [']d'] = { 'Next diagnostic' },
    ['[d'] = { 'Previous diagnostic' },
  }, { buffer = bufnr })
  wk.register({ ['<leader>c'] = { a = 'Code actions' } }, { mode = 'v', buffer = bufnr })

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    vim.api.nvim_create_autocmd('CursorHold', {
      group = 'lsp_document_highlight',
      pattern = '<buffer>',
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'lsp_document_highlight',
      pattern = '<buffer>',
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
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
        },
        tags = { skipUnexported = true },
      },
    }
  end,
  sumneko_lua = function()
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')
    return {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = runtime_path,
          },
          completion = { callSnippet = 'Both' },
          diagnostics = { globals = { 'vim' } },
          workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
          format = { enable = false },
          telemetry = { enable = false },
        },
      },
    }
  end,
  jdtls = function()
    return {
      -- cmd = {
      --     vim.fn.expand("$HOME/.local/share/nvim/lsp_servers/jdtls/jdtls.sh")
      -- },
      cmd_env = {
        JAVA_HOME = '/usr/lib/jvm/java-11-openjdk-amd64',
        GRADLE_HOME = vim.fn.expand('$HOME/gradle', nil, nil),
        JAR = vim.fn.expand(
          '$HOME/.local/share/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.2.400.*.jar'
        ),
        JDTLS_CONFIG = vim.fn.expand('$HOME/.local/share/nvim/lsp_servers/jdtls/config_linux', nil, nil),
        WORKSPACE = vim.fn.expand('$HOME/java/workspace', nil, nil),
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
    -- modify virtual text
    handlers = {
      ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = { prefix = ' ', spacing = 4 },
      }),
    },
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
  local lspconfig_icons = require('config.icons').lspconfig
  -- Update the sign icons
  for type, icon in pairs(lspconfig_icons) do
    local hl = 'LspDiagnosticsSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end

  -- Set borders to floating windows
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })
end

setup_servers()
customise_ui()
