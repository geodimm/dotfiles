local lspinstaller = require('nvim-lsp-installer')

vim.api.nvim_exec([[
augroup lsp_formatting
    autocmd!
    autocmd BufWritePre *.go,*.lua,*.tf,*.sh,*.bash,*.js,*.yaml,*.yml,*.json,*.html lua vim.lsp.buf.formatting_seq_sync()
    augroup end
]], false)

local completion_item_kind = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = '',
    Variable = '',
    Class = '',
    Interface = 'ﰮ',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '﬌',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    Event = '',
    Operator = 'ﬦ',
    TypeParameter = ''
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    local kinds = vim.lsp.protocol.CompletionItemKind
    for i, kind in ipairs(kinds) do
        kinds[i] = completion_item_kind[kind] or kind
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = {noremap = true, silent = true}

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<leader>gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>',
                   opts)
    buf_set_keymap('n', '<leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>',
                   opts)
    buf_set_keymap('n', '<leader>gt',
                   '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>gI',
                   '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>gi',
                   '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    buf_set_keymap('n', '<leader>go',
                   '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
    buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>',
                   opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>k',
                   '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',
                   opts)
    buf_set_keymap('v', '<leader>ca',
                   '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
                   opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
                   opts)
    buf_set_keymap('n', '<leader>cl',
                   '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>cf",
                       "<cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<leader>cf",
                       "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    local wk = require('which-key')
    wk.register({
        K = "Documentation",
        ["<leader>g"] = {
            name = "+goto",
            D = "Declaration",
            I = "Implementation",
            d = "Definition",
            i = "Incoming calls",
            o = "Outgoing calls",
            r = "References",
            t = "Type definition"
        },
        ["<leader>c"] = {
            name = "+lsp",
            a = "Code actions",
            f = "Format",
            l = "Populate location list",
            r = "Rename"
        },
        ["<leader>k"] = "Signature help",
        ["]d"] = {"Next diagnostic"},
        ["[d"] = {"Previous diagnostic"}
    }, {buffer = bufnr})
    wk.register({["<leader>c"] = {a = "Code actions"}},
                {mode = "v", buffer = bufnr})

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
            ]], false)
    end
end

-- Define LSP configuration settings for languages
local lsp_config = {
    gopls = {
        cmd = {vim.fn.expand("$HOME/go/bin/gopls"), "-remote=auto"},
        settings = {
            gopls = {
                buildFlags = {"-tags=all,test_setup"},
                codelenses = {
                    tidy = true,
                    vendor = true,
                    generate = true,
                    upgrade_dependency = true,
                    gc_details = true
                },
                analyses = {
                    ST1003 = false,
                    undeclaredname = true,
                    unusedparams = true,
                    fillreturns = true,
                    nonewvars = true
                },
                staticcheck = true,
                importShortcut = "Both",
                completionDocumentation = true,
                linksInHover = true,
                usePlaceholders = true,
                hoverKind = "FullDocumentation"
            },
            tags = {skipUnexported = true}
        }
    },
    sumneko_lua = require('lua-dev').setup(
        {lspconfig = {settings = {Lua = {diagnostics = {globals = {"use"}}}}}}),
    jdtls = {
        -- cmd = {
        --     vim.fn.expand("$HOME/.local/share/nvim/lsp_servers/jdtls/jdtls.sh")
        -- },
        cmd_env = {
            JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64",
            GRADLE_HOME = vim.fn.expand("$HOME/gradle"),
            JAR = vim.fn.expand(
                "$HOME/.local/share/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.2.400.v20211116-1129.jar"),
            JDTLS_CONFIG = vim.fn.expand(
                "$HOME/.local/share/nvim/lsp_servers/jdtls/config_linux")
        }
    },
    yamlls = {
        settings = {
            yaml = {
                hover = true,
                completion = true,
                format = {enable = true},
                validate = true,
                schemas = {
                    ["https://json.schemastore.org/golangci-lint.json"] = "*golangci.y*ml",
                    ["https://json.schemastore.org/kustomization.json"] = "/*kustomization.y*ml",
                    ["https://json.schemastore.org/swagger-2.0.json"] = "/*swagger.y*ml",
                    ["https://json.schemastore.org/travis.json"] = "/*travis.y*ml",
                    ["https://json.schemastore.org/yamllint.json"] = "/*yamllint.y*ml",
                    ["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/master/docs/content/en/schemas/v2beta12.json"] = "/*skaffold.y*ml"
                },
                schemaStore = {
                    url = "https://www.schemastore.org/json",
                    enable = true
                }
            }
        }
    },
    jsonls = {settings = {json = {format = {enable = true}}}},
    diagnosticls = {
        init_options = {
            linters = {
                ["golangci-lint"] = {
                    command = "golangci-lint",
                    args = {"run", "--out-format", "json"},
                    rootPatterns = {".git", "go.mod"},
                    sourceName = "golangci-lint",
                    debounce = 100,
                    parseJson = {
                        sourceName = "Pos.Filename",
                        sourceNameFilter = true,
                        errorsRoot = "Issues",
                        line = "Pos.Line",
                        column = "Pos.Column",
                        message = "${FromLinter}: ${Text}"
                    }
                },
                shellcheck = {
                    command = "shellcheck",
                    args = {"-x", "--format", "json", "-"},
                    sourceName = "shellcheck",
                    debounce = 100,
                    parseJson = {
                        line = "line",
                        column = "column",
                        endLine = "endLine",
                        endColumn = "endColumn",
                        message = "${message} [${code}]",
                        security = "level"
                    }
                },
                markdownlint = {
                    command = "markdownlint",
                    args = {"--stdin"},
                    sourceName = "markdownlint",
                    isStderr = true,
                    debounce = 100,
                    offsetLine = 0,
                    offsetColumn = 0,
                    formatLines = 1,
                    formatPattern = {
                        "^.*?:\\s?(\\d+)(:(\\d+)?)?\\s(MD\\d{3}\\/[A-Za-z0-9-/]+)\\s(.*)$",
                        {line = 1, column = 3, message = {4}}
                    }
                }
            },
            filetypes = {
                go = {"golangci-lint"},
                sh = {"shellcheck"},
                markdown = {"markdownlint"}
            },
            formatters = {
                ["lua-format"] = {command = "lua-format", args = {"-i"}},
                shfmt = {command = "shfmt", args = {"-"}}
            },
            formatFiletypes = {lua = {"lua-format"}, sh = {"shfmt"}}
        },
        filetypes = {"go", "lua", "sh", "markdown"}
    }
}

-- Create config that activates keymaps and enables snippet support
local function create_config(server)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport =
        {properties = {'documentation', 'detail', 'additionalTextEdits'}}
    local config = {
        -- enable snippet support
        capabilities = capabilities,
        -- map buffer local keybindings when the language server attaches
        on_attach = on_attach,
        -- modify virtual text
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    -- Disable virtual_text
                    virtual_text = {prefix = " ", spacing = 4}
                })
        }
    }

    local language_config = lsp_config[server.name]
    if language_config ~= nil then
        for k, v in pairs(language_config) do config[k] = v end
    end

    return config
end

-- Configure nvim-lsp-installer and lspconfig
local function setup_servers()

    local required_servers = {
        "gopls", "sumneko_lua", "bashls", "jsonls", "yamlls", "dockerls",
        "html", "terraformls", "pyright", "jdtls", "denols", "diagnosticls"
    }

    for _, name in pairs(required_servers) do
        local ok, server = lspinstaller.get_server(name)
        if ok then
            if not server:is_installed() then
                print("Installing " .. name)
                server:install()
            end
        end
    end

    lspinstaller.on_server_ready(function(server)
        local config = create_config(server)
        server:setup(config)
        vim.cmd([[ do User LspAttachBuffers ]])
    end)
end

local function customise_ui()
    local lspconfig_icons = require('config.icons').lspconfig
    -- Update the sign icons
    for type, icon in pairs(lspconfig_icons) do
        local hl = "LspDiagnosticsSign" .. type
        vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
    end

    -- Set borders to floating windows
    vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, {border = 'single'})
    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'single'})
end

setup_servers()
customise_ui()
