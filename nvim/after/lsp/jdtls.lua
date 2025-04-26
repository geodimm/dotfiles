return {
  settings = {
    java = {
      format = {
        enabled = false,
      },
      configuration = {
        runtimes = {
          {
            name = 'Java 23',
            path = os.getenv('JAVA_HOME'),
            default = true,
          },
        },
      },
      signatureHelp = {
        enabled = true,
      },
    },
  },
}
