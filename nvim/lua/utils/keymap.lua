M = {}

-- Set calls vim.keymap.set with sensible opts.
local function set(mode, lhs, rhs, opts)
  opts = opts or {}
  if opts.silent == nil then
    opts.silent = true
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Register group assigns a name for a keymap prefix in which-key
local function register_group(prefix, name, wk_opts, opts)
  local status_ok, wk = pcall(require, 'which-key')
  if not status_ok then
    return
  end

  wk_opts = vim.tbl_deep_extend('keep', { prefix, group = name }, wk_opts or {})
  wk.add(wk_opts, opts)
end

M.set = set
M.register_group = register_group

return M
