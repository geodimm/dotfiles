local M = {}

local diagnostic_data_key = 'golangci_lint'

local function issue_key(source, line, column, message)
  return table.concat({ source, line, column, message }, '\0')
end

local function issue_belongs_to_buffer(issue, bufnr, cwd)
  local filename = issue.Pos and issue.Pos.Filename
  if not filename then
    return false
  end

  local current = vim.fs.normalize(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p'))
  local reported = vim.fs.normalize(vim.fn.fnamemodify(filename, ':p'))
  local relative = vim.fs.normalize(vim.fn.fnamemodify(vim.fs.joinpath(cwd, filename), ':p'))
  return current == reported or current == relative
end

---Preserve golangci-lint's structured suggested fixes on nvim-lint diagnostics.
---@param linter lint.Linter
function M.attach(linter)
  if linter._golangci_actions_attached then
    return
  end

  linter._golangci_actions_attached = true
  local parse = linter.parser

  linter.parser = function(output, bufnr, cwd)
    local diagnostics = parse(output, bufnr, cwd)
    if output == '' or vim.bo[bufnr].modified then
      return diagnostics
    end

    local ok, result = pcall(vim.json.decode, output)
    if not ok or type(result) ~= 'table' or type(result.Issues) ~= 'table' then
      return diagnostics
    end

    local fixes_by_issue = {}
    for _, issue in ipairs(result.Issues) do
      if
        type(issue.SuggestedFixes) == 'table'
        and #issue.SuggestedFixes > 0
        and issue_belongs_to_buffer(issue, bufnr, cwd)
      then
        local key = issue_key(
          issue.FromLinter,
          math.max((issue.Pos.Line or 1) - 1, 0),
          math.max((issue.Pos.Column or 1) - 1, 0),
          issue.Text
        )
        fixes_by_issue[key] = fixes_by_issue[key] or {}
        table.insert(fixes_by_issue[key], issue.SuggestedFixes)
      end
    end

    local changedtick = vim.api.nvim_buf_get_changedtick(bufnr)
    for _, diagnostic in ipairs(diagnostics) do
      local key = issue_key(diagnostic.source, diagnostic.lnum, diagnostic.col, diagnostic.message)
      local matches = fixes_by_issue[key]
      if matches and #matches > 0 then
        diagnostic.user_data = diagnostic.user_data or {}
        diagnostic.user_data[diagnostic_data_key] = {
          changedtick = changedtick,
          fixes = table.remove(matches, 1),
        }
      end
    end

    return diagnostics
  end
end

local function byte_offset_to_position(lines, offset, encoding)
  local remaining = math.max(offset, 0) -- golangci-lint JSON offsets are zero-based bytes.

  for row, line in ipairs(lines) do
    if remaining <= #line then
      return {
        line = row - 1,
        character = vim.str_utfindex(line, encoding, remaining, false),
      }
    end
    remaining = remaining - #line - 1 -- Account for the newline.
  end

  local last = lines[#lines] or ''
  return {
    line = math.max(#lines - 1, 0),
    character = vim.str_utfindex(last, encoding),
  }
end

local function as_text_edits(fix, lines, encoding)
  local edits = {}
  for _, edit in ipairs(fix.TextEdits or {}) do
    if type(edit.Pos) == 'number' and type(edit.End) == 'number' then
      table.insert(edits, {
        range = {
          start = byte_offset_to_position(lines, edit.Pos, encoding),
          ['end'] = byte_offset_to_position(lines, edit.End, encoding),
        },
        newText = type(edit.NewText) == 'string' and vim.base64.decode(edit.NewText) or '',
      })
    end
  end
  return edits
end

local function requested_lines(params)
  local range = params.lsp_params and params.lsp_params.range
  if not range then
    return params.row - 1, params.row - 1
  end

  return range.start.line, range['end'].line
end

local function actions_for_request(params)
  local ok, lint = pcall(require, 'lint')
  if not ok or vim.bo[params.bufnr].modified then
    return {}
  end

  local first_line, last_line = requested_lines(params)
  local actions = {}
  local changedtick = vim.api.nvim_buf_get_changedtick(params.bufnr)
  local version = vim.lsp.util.buf_versions[params.bufnr] or 0
  local uri = vim.uri_from_bufnr(params.bufnr)

  for _, diagnostic in ipairs(vim.diagnostic.get(params.bufnr, { namespace = lint.get_namespace('golangcilint') })) do
    local data = diagnostic.user_data and diagnostic.user_data[diagnostic_data_key]
    if data and data.changedtick == changedtick and diagnostic.lnum >= first_line and diagnostic.lnum <= last_line then
      for _, fix in ipairs(data.fixes) do
        local edits = as_text_edits(fix, params.content, 'utf-8')
        if #edits > 0 then
          local title = fix.Message ~= '' and fix.Message or diagnostic.message
          table.insert(actions, {
            title = ('%s [%s]'):format(title, diagnostic.source),
            kind = 'quickfix',
            edit = {
              documentChanges = {
                {
                  textDocument = { uri = uri, version = version },
                  edits = edits,
                },
              },
            },
            -- none-ls requires a callback and turns it into a command. Neovim
            -- applies the edit first; the versioned document keeps it safe.
            action = function() end,
          })
        end
      end
    end
  end

  return actions
end

---Expose cached golangci-lint suggested fixes through none-ls.
---@return table
function M.code_action_source()
  return {
    name = 'golangci_lint_code_actions',
    method = require('null-ls.methods').internal.CODE_ACTION,
    filetypes = { 'go' },
    generator = {
      fn = actions_for_request,
    },
  }
end

return M
