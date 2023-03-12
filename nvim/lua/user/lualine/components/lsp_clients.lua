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

M.update_status = function(self)
  local opts = self.options
  local result = {}
  local progress = 0
  local client_names = {}

  local active_clients = vim.lsp.get_active_clients({ bufnr = 0 })
  for _, client in pairs(active_clients) do
    if client.name ~= 'null-ls' then
      table.insert(client_names, client.name)

      if opts.progress.enabled then
        local data = client.messages
        progress = #data.progress > 0 and 10 or 0
        for _, ctx in pairs(data.progress) do
          local current = ctx.done and 10 or math.floor(ctx.percentage / 10)
          progress = math.min(current, progress)
        end
      end
    else
      if opts.names.null_ls.include then
        local available_sources = require('null-ls.sources').get_available(vim.bo.filetype)
        local registered = {}
        for _, source in ipairs(available_sources) do
          for method in pairs(source.methods) do
            registered[method] = registered[method] or {}
            table.insert(registered[method], source.name)
          end
        end

        for _, method in ipairs(opts.names.null_ls.methods) do
          vim.list_extend(client_names, registered[method] or {})
        end
      end
    end
  end

  if opts.progress.enabled then
    local icon = opts.progress.symbols[progress]
    local hl_group = ''
    if opts.progress.colors.enabled then
      local hl
      if progress == 0 then
        hl = self.highlights.progress.inactive
      elseif progress == 10 then
        hl = self.highlights.progress.done
      else
        hl = self.highlights.progress.loading
      end
      hl_group = highlight.component_format_highlight(hl)
    end

    table.insert(result, hl_group .. icon)
  end

  local clients = table.concat(vim.fn.uniq(client_names), ', ')
  local hl_group = ''
  if opts.names.colors.enabled then
    local hl
    if clients ~= '' then
      hl = self.highlights.names.active
    else
      hl = self.highlights.names.inactive
    end
    hl_group = highlight.component_format_highlight(hl)
  end

  table.insert(result, hl_group .. (clients ~= '' and clients or opts.names.inactive_message))

  return table.concat(result, ' ')
end

return M
