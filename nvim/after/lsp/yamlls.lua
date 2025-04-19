return {
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.github' },
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
