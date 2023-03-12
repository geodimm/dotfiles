local highlight = require('lualine.highlight')

local M = require('lualine.component'):extend()

local icons = require('user.icons')

local default_options = {
  progress = {
    enabled = true,
    colors = {
      inactive = 'red',
      loading = 'yellow',
      done = 'green',
      enabled = true,
    },
    symbols = icons.lsp_progress,
  },
  names = {
    inactive_message = 'No LSP',
    colors = {
      inactive = 'red',
      active = 'green',
      enabled = true,
    },
    null_ls = {
      include = true,
      methods = {
        require('null-ls').methods.FORMATTING,
        require('null-ls').methods.DIAGNOSTICS,
      },
    },
  },
}

-- Initializer
M.init = function(self, options)
  M.super.init(self, options)

  self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
  self.highlights = {
    progress = {
      inactive = {},
      loading = {},
      done = {},
    },
    names = {
      inactive = {},
      active = {},
    },
  }

  if self.options.progress.enabled and self.options.progress.colors.enabled then
    self.highlights.progress.inactive = highlight.create_component_highlight_group(
      { fg = self.options.progress.colors.inactive },
      'lspclients_progress_inactive',
      self.options
    )
    self.highlights.progress.loading = highlight.create_component_highlight_group(
      { fg = self.options.progress.colors.loading },
      'lspclients_progress_loading',
      self.options
    )
    self.highlights.progress.done = highlight.create_component_highlight_group(
      { fg = self.options.progress.colors.done },
      'lsplcients_progress_done',
      self.options
    )
  end

  if self.options.names.colors.enabled then
    self.highlights.names.inactive = highlight.create_component_highlight_group(
      { fg = self.options.names.colors.inactive },
      'lspclients_names_inactive',
      self.options
    )
    self.highlights.names.active = highlight.create_component_highlight_group(
      { fg = self.options.names.colors.active },
      'lspclients_names_active',
      self.options
    )
  end
end

local function get_progress(client)
  local data = client.messages
  local progress = 0
  if not vim.tbl_isempty(data.progress) then
    progress = 10
    for _, ctx in pairs(data.progress) do
      local current = ctx.done and 10 or math.floor((ctx.percentage or 0) / 10)
      progress = math.min(current, progress)
    end
  end

  return progress
end

local function get_null_ls_client_names(opts)
  local available_sources = require('null-ls.sources').get_available(vim.bo.filetype)
  local registered_clients = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered_clients[method] = registered_clients[method] or {}
      table.insert(registered_clients[method], source.name)
    end
  end

  local client_names = {}
  for _, method in ipairs(opts.names.null_ls.methods) do
    vim.list_extend(client_names, registered_clients[method] or {})
  end

  table.sort(client_names)
  return vim.fn.uniq(client_names)
end

M.update_status = function(self)
  local opts = self.options
  local progress = 0
  local client_names = {}

  local active_clients = vim.lsp.get_active_clients({ bufnr = 0 })
  for _, client in pairs(active_clients) do
    if client.name ~= 'null-ls' then
      table.insert(client_names, client.name)
      if opts.progress.enabled then
        progress = get_progress(client)
      end
    else
      if opts.names.null_ls.include then
        vim.list_extend(client_names, get_null_ls_client_names(opts))
      end
    end
  end

  local result = {}
  if opts.progress.enabled then
    table.insert(result, self:format_progress(progress))
  end

  table.insert(result, self:format_client_names(client_names))
  return table.concat(result, ' ')
end

M.format_progress = function(self, progress)
  local opts = self.options
  local icon = opts.progress.symbols[progress]
  local hl_group = ''

  if opts.progress.colors.enabled then
    local hl = ({ [0] = 'inactive', [10] = 'done' })[progress] or 'loading'
    hl_group = highlight.component_format_highlight(self.highlights.progress[hl])
  end

  return hl_group .. icon
end

M.format_client_names = function(self, client_names)
  local opts = self.options
  local value = table.concat(client_names, ', ')
  local hl_group = ''

  if opts.names.colors.enabled then
    local hl = value ~= '' and 'active' or 'inactive'
    hl_group = highlight.component_format_highlight(self.highlights.names[hl])
  end

  local clients = value ~= '' and value or opts.names.inactive_message
  return hl_group .. clients
end

return M
