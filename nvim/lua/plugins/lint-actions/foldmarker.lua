-- Offer a fold marker modeline when a buffer uses fold markers but has none.
local M = {}

local open_marker = '{{{'
local close_marker = '}}}'
local modeline = 'vim: foldmethod=marker'

---@param line string
---@return boolean
local function is_foldmarker_modeline(line)
  if not line:find('[vV]im?:') and not line:find('[eE]x:') then
    return false
  end

  local compact = line:gsub('%s', '')
  return compact:find('foldmethod=marker', 1, true) ~= nil or compact:find('fdm=marker', 1, true) ~= nil
end

---Vim only honours a modeline within `'modelines'` lines of either end, so a
---modeline buried in the middle of the file does not count as already set.
---@param lines string[]
---@return boolean
local function has_modeline(lines)
  local window = math.max(vim.o.modelines, 0)
  for index = 1, math.min(window, #lines) do
    if is_foldmarker_modeline(lines[index]) then
      return true
    end
  end
  for index = math.max(#lines - window + 1, 1), #lines do
    if is_foldmarker_modeline(lines[index]) then
      return true
    end
  end
  return false
end

---@param lines string[]
---@return boolean
local function uses_fold_markers(lines)
  local has_open = false
  local has_close = false

  for _, line in ipairs(lines) do
    has_open = has_open or line:find(open_marker, 1, true) ~= nil
    has_close = has_close or line:find(close_marker, 1, true) ~= nil
    if has_open and has_close then
      return true
    end
  end
  return false
end

---Render the modeline as a comment for the buffer's language.
---@param bufnr integer
---@return string?
local function commented_modeline(bufnr)
  local commentstring = vim.bo[bufnr].commentstring
  if commentstring == '' or not commentstring:find('%%s') then
    return nil
  end
  return (commentstring:gsub('%%s', modeline, 1))
end

---Keep a shebang and an encoding declaration first, since both must stay on
---the lines where they are.
---@param lines string[]
---@return integer
local function insertion_line(lines)
  local line = lines[1] and lines[1]:sub(1, 2) == '#!' and 1 or 0
  local possible_encoding_line = lines[line + 1] or ''
  if possible_encoding_line:find('coding[:=]%s*[-%w_.]+') then
    line = line + 1
  end
  return line
end

---@param context LintActions.ProviderContext
---@return LintActions.Item[]
function M.provide(context)
  local rendered_modeline = commented_modeline(context.bufnr)
  if not rendered_modeline then
    return {}
  end

  local lines = vim.api.nvim_buf_get_lines(context.bufnr, 0, -1, false)
  if has_modeline(lines) or not uses_fold_markers(lines) then
    return {}
  end

  local insert_at = insertion_line(lines)
  return {
    {
      -- No range: the modeline concerns the whole buffer, so offer the action
      -- wherever the cursor is. The edit still targets one exact position.
      action = {
        title = 'Add fold marker modeline',
        kind = 'quickfix',
        isPreferred = true,
        edit = {
          range = {
            start = { line = insert_at, character = 0 },
            ['end'] = { line = insert_at, character = 0 },
          },
          newText = rendered_modeline .. '\n',
        },
      },
    },
  }
end

function M.setup()
  require('lint_actions').register({
    source = 'foldmarker-modeline',
    provide = M.provide,
    enabled = function(bufnr)
      return vim.bo[bufnr].modifiable
    end,
  })
end

return M
