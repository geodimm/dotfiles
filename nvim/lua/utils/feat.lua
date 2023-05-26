local M = {}

-- diagnostics is map[number]bool which keeps the current status of
-- lsp diagnostics for each buffer.
local Feature = { buffers = {} }

function Feature:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

function Feature:set(bufnr, enabled)
  self.buffers[bufnr] = enabled
end

function Feature:is_disabled(bufnr)
  return not self.buffers[bufnr]
end

M.Diagnostics = Feature:new()
M.Formatting = Feature:new()

return M
