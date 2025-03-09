local M = {}

local Feature = { buffers = {} }

function Feature:new(o)
  o = o or {} -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

function Feature:set(bufnr, enabled)
  bufnr = bufnr == 0 and vim.fn.bufnr('%') or bufnr
  self.buffers[bufnr] = enabled
end

function Feature:is_enabled(bufnr)
  bufnr = bufnr == 0 and vim.fn.bufnr('%') or bufnr
  return self.buffers[bufnr]
end

M.Formatting = Feature:new()

return M
