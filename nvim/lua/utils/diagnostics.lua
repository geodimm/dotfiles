local M = {}

-- diagnostics is map[number]bool which keeps the current status of
-- lsp diagnostics for each buffer.
local diagnostics = {}

-- set updates the status of lsp diagnostics for a buffer
local function set(bufnr, enabled)
  diagnostics[bufnr] = enabled
end

-- is_disabled returns whether lsp diagnostics are disabled for a buffer
local function is_disabled(bufnr)
  return not diagnostics[bufnr]
end

M.set = set
M.is_disabled = is_disabled

return M
