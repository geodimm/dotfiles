local status_ok, jdtls
status_ok, jdtls = pcall(require, 'jdtls')
if not status_ok then
  return
end

local config = {
  cmd = {
    vim.fn.stdpath('data') .. '/mason/bin/jdtls',
    '-data',
    vim.fn.expand('$HOME/java/workspace/') .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
  },
  root_dir = vim.fs.dirname(vim.fs.find({ '.gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  on_attach = require('utils.lsp').on_attach,
  settings = {
    java = {
      format = {
        enabled = true,
        settings = {
          profile = 'GoogleStyle',
          url = 'https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml',
        },
      },
      saveActions = {
        organizeImports = true,
      },
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-1.8',
            path = '/usr/lib/jvm/java-8-openjdk-amd64/',
          },
          {
            name = 'JavaSE-11',
            path = '/usr/lib/jvm/java-11-openjdk-amd64/',
          },
          {
            name = 'JavaSE-17',
            path = '/usr/lib/jvm/java-17-openjdk-amd64/',
          },
        },
      },
    },
  },
}

jdtls.start_or_attach(config)
