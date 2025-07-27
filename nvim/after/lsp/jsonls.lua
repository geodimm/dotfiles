return {
  settings = {
    json = {
      format = {
        enable = true,
      },
      schemas = require('schemastore').json.schemas(),
      validate = {
        enable = true,
      },
    },
  },
}
