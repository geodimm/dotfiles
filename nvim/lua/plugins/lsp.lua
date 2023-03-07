local icons = require('user.icons')
local lsp_utils = require('utils.lsp')

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

-- Define LSP configuration settings for languages
local servers_config = {
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

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    init = function()
      lsp_utils.customise_ui()
      lsp_utils.setup_vim_diagnostics()
    end,
    config = function()
      local nvim_lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')
      for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
        if server == 'jdtls' then
          goto continue -- see nvim/ftplugin/java.lua instead
        end
        local config = lsp_utils.create_config(servers_config, server)
        nvim_lspconfig[server].setup(config)
        ::continue::
      end

      if vim.fn.executable('tilt') then
        local config = lsp_utils.create_config(servers_config, 'tilt_ls')
        nvim_lspconfig['tilt_ls'].setup(config)
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
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    init = function()
      -- Notify when Mason tools are updated
      vim.api.nvim_create_augroup('user_mason_tool_update', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = 'user_mason_tool_update',
        desc = 'send a notification when Mason tools are updated',
        pattern = 'MasonToolsUpdateCompleted',
        callback = function()
          vim.notify('Successfully updated Mason tools', vim.log.levels.INFO)
        end,
      })
    end,
    opts = {
      ensure_installed = lsp_tools,
      auto_update = true,
      run_on_start = true,
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
        on_attach = lsp_utils.on_attach,
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
    'SmiteshP/nvim-navic',
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = {
      highlight = true,
      separator = ' ' .. icons.ui.breadcrumb .. ' ',
    },
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
