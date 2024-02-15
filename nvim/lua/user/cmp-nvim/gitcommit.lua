local cc = {
  {
    label = 'build',
    documentation = 'Changes that affect the build system or external dependencies',
  },
  {
    label = 'chore',
    documentation = 'Other changes that dont modify src or test files',
  },
  {
    label = 'ci',
    documentation = 'Changes to our CI configuration files and scripts',
  },
  {
    label = 'docs',
    documentation = 'Documentation only changes',
  },
  {
    label = 'feat',
    documentation = 'A new feature',
  },
  {
    label = 'fix',
    documentation = 'A bug fix',
  },
  {
    label = 'perf',
    documentation = 'A code change that improves performance',
  },
  {
    label = 'refactor',
    documentation = 'A code change that neither fixes a bug nor adds a feature',
  },
  {
    label = 'style',
    documentation = 'Changes that do not affect the meaning of the code',
  },
  {
    label = 'test',
    documentation = 'Adding missing tests or correcting existing tests',
  },
}

local items = {}
for k, v in ipairs(cc) do
  items[k] = {
    label = v.label,
    kind = require('cmp').lsp.CompletionItemKind.Keyword,
    documentation = v.documentation,
  }
end

local source = {}

function source:is_available()
  return vim.bo.filetype == 'gitcommit'
end

function source:complete(request, callback)
  callback(items)
end

require('cmp').register_source('gitcommit', source)
