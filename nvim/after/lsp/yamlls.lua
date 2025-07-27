return {
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.github' },
  settings = {
    yaml = {
      hover = true,
      completion = true,
      format = {
        enable = true,
      },
      validate = true,
      schemas = require('schemastore').yaml.schemas(),
      schemaStore = {
        enable = false,
        url = '',
      },
    },
  },
}
