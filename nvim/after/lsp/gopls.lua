local buildFlags = {}
for w in (os.getenv('GOPLS_BUILD_FLAGS') or ''):gmatch('%S+') do
  table.insert(buildFlags, w)
end

return {
  -- Keep gopls built by the active Go toolchain. Mason's prebuilt binary can
  -- lag behind it and suppress version-gated modernize diagnostics/actions.
  cmd = { vim.fn.expand('~/go/bin/gopls') },
  settings = {
    gopls = {
      -- build
      buildFlags = buildFlags,
      templateExtensions = { 'tmpl' },
      -- formatting
      gofumpt = true,
      -- UI
      codelenses = {
        test = true,
        vulncheck = true,
      },
      semanticTokens = true,
      -- completion
      usePlaceholders = true,
      -- diagnostic; gopls enables its modernize analyzers by default
      analyses = {
        appendclipped = true,
        shadow = true,
        slicesdelete = true,
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
        ignoredError = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      -- navigation
      importShortcut = 'Both',
    },
  },
}
