local lsp_tools = {
  -- language servers
  'bash-language-server',
  'deno',
  'dockerfile-language-server',
  'gopls',
  'html-lsp',
  'jdtls',
  'json-lsp',
  'lua-language-server',
  'marksman',
  'pyright',
  'taplo',
  'terraform-ls',
  'yaml-language-server',

  -- linters
  'actionlint',
  'golangci-lint',
  'hadolint',
  'jsonlint',
  'markdownlint',

  -- formatters
  'shfmt',
  'stylua',
}

local required_servers = {
  'bashls',
  'denols',
  'dockerls',
  'gopls',
  'html',
  'jdtls',
  'jsonls',
  'lua_ls',
  'marksman',
  'pyright',
  'taplo',
  'terraformls',
  'yamlls',
}

local required_linters = {
  -- linters
  'actionlint',
  'golangci-lint',
  'hadolint',
  'jsonlint',
  'markdownlint',

  -- formatters
  'shfmt',
  'stylua',
}

local icons = require('user.icons')

-- Define LSP configuration settings for languages
local lsp_server_config = {
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
            run_vulncheck_exp = true,
          },
          analyses = {
            useany = true,
            nilness = true,
            unusedparams = true,
            unusedvariable = true,
            unusedwrite = true,
            shadow = true,
          },
          semanticTokens = true,
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
  lua_ls = function()
    local ok, neodev = pcall(require, 'neodev')
    if not ok then
      vim.notify("Cannot import 'neodev'. Using empty config", vim.log.levels.WARN)
      return {}
    end

    neodev.setup({})

    return {
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          format = { enable = false },
        },
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
            ['https://json.schemastore.org/chart.json'] = '/kubernetes/*.y*ml',
            ['https://json.schemastore.org/golangci-lint.json'] = '*golangci.y*ml',
            ['https://json.schemastore.org/kustomization.json'] = '/*kustomization.y*ml',
            ['https://json.schemastore.org/swagger-2.0.json'] = '/*swagger.y*ml',
            ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
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
  tilt_ls = function()
    return {
      filetypes = { 'tiltfile', 'starlark' },
    }
  end,
}

-- Create config that activates keymaps and enables snippet support
local function create_config(server)
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  local opts = {
    capabilities = capabilities,
    on_attach = require('utils.lsp').on_attach,
  }

  if lsp_server_config[server] then
    opts = vim.tbl_deep_extend('force', opts, lsp_server_config[server]())
  end

  return opts
end

local function customise_ui()
  -- Update the sign icons
  for type, icon in pairs(icons.lspconfig) do
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

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    init = function()
      customise_ui()
      setup_vim_diagnostics()
    end,
    config = function()
      local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')
      for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
        if server == 'jdtls' then
          goto continue -- see nvim/ftplugin/java.lua instead
        end
        local config = create_config(server)
        lspconfig[server].setup(config)
        ::continue::
      end

      if vim.fn.executable('tilt') then
        local config = create_config('tilt_ls')
        lspconfig['tilt_ls'].setup(config)
      end
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = {
      ui = {
        border = 'rounded',
        icons = {
          package_installed = icons.ui.check,
          package_pending = icons.ui.play,
          package_uninstalled = icons.ui.close,
        },
      },
    },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = required_servers,
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = lsp_tools,
      auto_update = false,
      run_on_start = false,
    },
  },
  {
    'SmiteshP/nvim-navic',
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = {
      highlight = true,
      separator = ' ' .. icons.ui.breadcrumb .. ' ',
    },
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        debug = false,
        diagnostics_format = '#{m}',
        on_attach = require('utils.lsp').on_attach,
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
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    init = function()
      vim.fn.sign_define('LightBulbSign', { text = icons.ui.lightbulb, texthl = 'Character', linehl = '', numhl = '' })
    end,
    opts = {
      autocmd = {
        enabled = true,
      },
    },
  },
  { 'folke/neodev.nvim' },
  { 'mfussenegger/nvim-jdtls' },
}
