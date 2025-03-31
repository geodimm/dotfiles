local icons = require('user.icons')
local lsp_utils = require('utils.lsp')
local feat = require('utils.feat')

local lsp_tools = {
  -- language servers
  'bash-language-server',
  'clangd',
  'deno',
  'dockerfile-language-server',
  'gopls',
  'helm-ls',
  'html-lsp',
  'json-lsp',
  'lua-language-server',
  'marksman',
  'pyright',
  'rust-analyzer',
  'taplo',
  'terraform-ls',
  'yaml-language-server',

  -- linters
  'actionlint',
  'golangci-lint',
  'hadolint',
  'markdownlint',

  -- formatters
  'gci',
  'goimports',
  'gofumpt',
  'shfmt',
  'stylua',
  'buildifier',

  -- code actions
  'gomodifytags',
}

-- Define LSP configuration settings for languages
local servers_config = {
  gopls = function()
    local buildFlags = {}
    for w in (os.getenv('GOPLS_BUILD_FLAGS') or ''):gmatch('%S+') do
      table.insert(buildFlags, w)
    end

    return {
      settings = {
        gopls = {
          -- build
          buildFlags = buildFlags,
          templateExtensions = { 'tmpl' },
          -- formatting
          gofumpt = true,
          -- ui
          codelenses = {
            test = true,
            run_govulncheck = true,
          },
          semanticTokens = true,
          -- completion
          usePlaceholders = true,
          -- diagnostic
          analyses = {
            shadow = true,
          },
          staticcheck = true,
          vulncheck = 'Imports',
          -- documentation
          hoverKind = 'FullDocumentation',
          linksInHover = true,
          -- inlay hints
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          -- navigation
          importShortcut = 'Both',
        },
        tags = { skipUnexported = true },
      },
    }
  end,
  lua_ls = function()
    return {
      settings = {
        Lua = {
          hint = {
            enable = true,
          },
          workspace = {
            checkThirdParty = false,
          },
          format = { enable = false },
          diagnostics = {
            globals = { 'vim', 'Snacks' },
          },
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
            ['https://json.schemastore.org/yamllint.json'] = '/*yamllint.y*ml',
            ['https://json.schemastore.org/markdownlint.json'] = '*markdownlint.y*ml',
            ['https://raw.githubusercontent.com/GoogleContainerTools/skaffold/refs/heads/main/docs-v2/content/en/schemas/v2beta16.json'] = '/*skaffold.y*ml',
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
  clangd = function()
    return {
      capabilities = {
        offsetEncoding = { 'utf-16' },
      },
    }
  end,
}

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {
          ui = {
            border = 'rounded',
            icons = {
              package_installed = icons.ui.check,
              package_pending = icons.ui.play,
              package_uninstalled = icons.ui.times,
            },
          },
        },
      },
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
          ensure_installed = lsp_tools,
          auto_update = true,
          run_on_start = true,
        },
      },
    },
    init = function()
      require('lspconfig.ui.windows').default_options.border = 'rounded'
      vim.diagnostic.config({
        underline = false,
        virtual_lines = {
          current_line = true,
        },
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
        },
        update_in_insert = false,
        severity_sort = true,
      })

      -- Add rounded border to lsp windows only
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      ---@diagnostic disable-next-line: duplicate-set-field
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or 'rounded'
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end
    end,
    config = function()
      local nvim_lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')
      for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
        local config = lsp_utils.create_config(servers_config, server)
        nvim_lspconfig[server].setup(config)
      end

      if vim.fn.executable('tilt') then
        local config = lsp_utils.create_config(servers_config, 'tilt_ls')
        nvim_lspconfig['tilt_ls'].setup(config)
      end
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        if not feat.Formatting:is_enabled(bufnr) then
          return
        end
        return {
          timeout_ms = 5000,
          lsp_format = 'fallback',
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'gofumpt', 'goimports' },
        sh = { 'shfmt' },
        markdown = { 'markdownlint' },
        rust = { 'rustfmt' },
        starlark = { 'buildifier' },
      },
      formatters = {
        markdownlint = {
          prepend_args = {
            '--config',
            vim.fn.expand('$HOME/dotfiles/markdownlint/markdownlint.yaml'),
          },
        },
      },
    },
  },
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    opts = {
      debug = false,
      diagnostics_format = '#{m}',
      on_attach = lsp_utils.on_attach,
    },
    config = function(_, opts)
      local null_ls = require('null-ls')

      opts.sources = {
        -- diagnostics
        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.markdownlint.with({
          extra_args = {
            '--config',
            vim.fn.expand('$HOME/dotfiles/markdownlint/markdownlint.yaml'),
          },
        }),
        null_ls.builtins.diagnostics.zsh,
        null_ls.builtins.diagnostics.actionlint,

        -- code actions
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.code_actions.gomodifytags,

        -- hover
        null_ls.builtins.hover.dictionary,
      }

      null_ls.setup(opts)
    end,
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-tree.lua',
    },
    opts = {},
  },
}
