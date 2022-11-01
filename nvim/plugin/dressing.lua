local status_ok, dressing, telescope_themes
status_ok, dressing = pcall(require, 'dressing')
if not status_ok then
  return
end
status_ok, telescope_themes = pcall(require, 'telescope.themes')
if not status_ok then
  return
end

-- adopted from https://github.com/stevearc/dressing.nvim/blob/12b808a6867e8c38015488ad6cee4e3d58174182/lua/dressing/select/telescope.lua#L8
local indexed_selection = function(opts, defaults, items)
  local entry_display = require('telescope.pickers.entry_display')
  local finders = require('telescope.finders')
  local displayer

  local function make_display(entry)
    local columns = {
      { entry.idx .. ':', 'TelescopePromptPrefix' },
      entry.text,
      { entry.kind, 'Comment' },
    }
    return displayer(columns)
  end

  local entries = {}
  local kind_width = 1
  local text_width = 1
  local idx_width = 1
  for idx, item in ipairs(items) do
    local text = opts.format_item(item)
    local kind = opts.kind

    kind_width = math.max(kind_width, vim.api.nvim_strwidth(kind))
    text_width = math.max(text_width, vim.api.nvim_strwidth(text))
    idx_width = math.max(idx_width, vim.api.nvim_strwidth(tostring(idx)))

    table.insert(entries, {
      idx = idx,
      display = make_display,
      text = text,
      kind = kind,
      ordinal = idx .. ' ' .. text .. ' ' .. kind,
      value = item,
    })
  end
  displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = idx_width + 1 },
      { width = text_width },
      { width = kind_width },
    },
  })

  defaults.finder = finders.new_table({
    results = entries,
    entry_maker = function(item)
      return item
    end,
  })
end

-- customise the telescope entry style for spellsuggest selections
require('dressing.select.telescope').custom_kind['spellsuggest'] = indexed_selection

dressing.setup({
  input = {
    winblend = 0,
    insert_only = false,
    prompt_align = 'center',
    relative = 'editor',
    prefer_width = 0.5,
  },
  select = {
    telescope = telescope_themes.get_cursor({
      layout_config = {
        width = function(_, max_columns, _)
          return math.min(max_columns, 80)
        end,
        height = function(_, _, max_lines)
          return math.min(max_lines, 15)
        end,
      },
    }),
  },
})
