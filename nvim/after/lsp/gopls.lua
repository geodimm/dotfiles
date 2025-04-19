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
      -- UI
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
