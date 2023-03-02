local name = 'catppuccin'

local function setup_catppuccin()
  local status_ok, catppuccin = pcall(require, 'catppuccin')
  if not status_ok then
    return
  end

  local config = {
    flavour = 'macchiato',
    transparent_background = true,
    integrations = {
      nvimtree = true,
      navic = {
        enabled = true,
      },
      mason = true,
      notify = true,
      which_key = true,
    },
  }

  catppuccin.setup(config)
end

local setup = function()
  vim.opt.background = 'dark'
  if name == 'catppuccin' then
    setup_catppuccin()
  end
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, 'colorscheme ' .. name)
end

M.name = name
M.setup = setup

return M
