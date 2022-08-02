local status_ok, refactoring = pcall(require, 'refactoring')
if not status_ok then
  return
end

refactoring.setup({})
