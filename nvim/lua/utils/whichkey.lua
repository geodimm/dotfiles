local M = {}

M.dump = function(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. M.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

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
