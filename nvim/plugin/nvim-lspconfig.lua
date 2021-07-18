local lspinstall = require 'lspinstall'
local lspconfig = require 'lspconfig'

vim.api.nvim_exec([[
augroup lsp_formatting
    autocmd!
    autocmd BufWritePre *.go,*.lua,*.tf,*.sh,*.bash lua vim.lsp.buf.formatting_seq_sync()
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

local lsp_icons = {
    Hint = "",
    Information = "",
    Warning = "",
    Error = ""
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

    local wk = require("which-key")
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
    go = {
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
    lua = {
        settings = {
            Lua = {
                runtime = {
                    -- LuaJIT in the case of Neovim
                    version = 'LuaJIT',
                    path = vim.split(package.path, ';')
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                    }
                }
            }
        }
    },
    java = {
        cmd = {
            vim.fn.expand("$HOME/.local/share/nvim/lspinstall/java/jdtls.sh")
        },
        cmd_env = {
            JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64",
            GRADLE_HOME = vim.fn.expand("$HOME/gradle"),
            JAR = vim.fn.expand(
                "$HOME/.local/share/nvim/lspinstall/java/plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.2.300.v20210617-0451.jar"),
            JDTLS_CONFIG = vim.fn.expand(
                "$HOME/.local/share/nvim/lspinstall/java/config_linux")
        }
    },
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

    local language_config = lsp_config[server]
    if language_config ~= nil then
        for k, v in pairs(language_config) do config[k] = v end
    end

    return config
end

-- Configure lsp-install and lspconfig
local function setup_servers()
    lspinstall.setup()

    local required_servers = {
        "go", "lua", "bash", "json", "yaml", "dockerfile", "html", "terraform",
        "python", "java"
    }
    local installed_servers = lspinstall.installed_servers()
    for _, server in pairs(required_servers) do
        if not vim.tbl_contains(installed_servers, server) then
            lspinstall.install_server(server)
        end
    end

    installed_servers = lspinstall.installed_servers()
    for _, server in pairs(installed_servers) do
        local config = create_config(server)
        lspconfig[server].setup(config)
    end
end

local function customise_ui()
    -- Update the sign icons
    for type, icon in pairs(lsp_icons) do
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

-- automatically setup servers again after `:LspInstall <server>`
lspinstall.post_install_hook = function()
    setup_servers() -- makes sure the new server is setup in lspconfig
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
