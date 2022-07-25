local M = {}

local status_ok, wk
status_ok, wk = pcall(require, 'which-key')

M.register = function(...)
  if not status_ok then
    return
  end
  for _, v in ipairs({ ... }) do
    wk.register(v.mappings, v.opts)
  end
end

return M
