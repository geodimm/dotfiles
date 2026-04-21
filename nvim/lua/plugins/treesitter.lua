-- Treesitter (1.x) + Neovim 0.11+ are not the “configs().highlight.enable = true” world anymore:
-- • Old plugin: automatic attach; 1.x: you call |vim.treesitter.start| (e.g. on FileType) — :h
--   nvim-treesitter rewrite.
-- Eagerly calling setup() in init reorders work vs. lazy.nvim’s typical
--   `event = { "BufReadPost", "BufNewFile" }` + :TSUpdate. We mimic that with defer_bootstrap().

local M = {}
M._inited = false
M._bootstraps_registered = false

--- Register one-shot autocommands; first real buffer or |VimEnter| runs the heavy setup.
--- Same idea as lazy.nvim `event` + one-time load, without blocking the rest of your init.
function M.defer_bootstrap()
  if M._bootstraps_registered then
    return
  end
  M._bootstraps_registered = true

  local ag = vim.api.nvim_create_augroup('user_treesitter_bootstrap', { clear = true })
  local function load()
    M.setup()
  end

  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = ag,
    once = true,
    desc = 'nvim-treesitter: first buffer (lazy-style BufReadPost/BufNewFile)',
    callback = load,
  })
  -- No-args `nvim` / dashboard: may not get a “user” BufReadPost; still need parsers before :e a file.
  vim.api.nvim_create_autocmd('VimEnter', {
    group = ag,
    once = true,
    desc = 'nvim-treesitter: bootstrap if nothing else fired (e.g. empty session)',
    callback = load,
  })
end

function M.setup()
  if M._inited then
    return
  end
  M._inited = true

  local ts = require('nvim-treesitter')
  local keymap = require('utils.keymap')

  ts.setup({})

  local ensure_parsers = {
    'bash',
    'css',
    'dockerfile',
    'git_config',
    'go',
    'gomod',
    'gosum',
    'gotmpl',
    'gowork',
    'hcl',
    'helm',
    'html',
    'html_tags',
    'http',
    'java',
    'javascript',
    'jq',
    'json',
    'json5',
    'jsx',
    'kitty',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'pem',
    'python',
    'regex',
    'ruby',
    'rust',
    'scss',
    'ssh_config',
    'sql',
    'starlark',
    'terraform',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'vue',
    'xml',
    'yaml',
  }

  local group = vim.api.nvim_create_augroup('user_treesitter_setup', { clear = true })

  local indent = "v:lua.require'nvim-treesitter'.indentexpr()"

  local function attach_ts(buf)
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    if vim.bo[buf].buftype ~= '' or vim.bo[buf].filetype == 'bigfile' then
      return
    end
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      local function apply()
        vim.bo[buf].indentexpr = indent
      end
      if pcall(vim.treesitter.start, buf) then
        apply()
        return
      end
      vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        if pcall(vim.treesitter.start, buf) then
          apply()
        end
      end, 0)
    end)
  end

  -- Like old |highlight = { enable = true }|: buffers that got FileType *before* this setup ran
  -- (e.g. arglist) never saw this autocmd; re-attach for every open buffer.
  local function reattach_all_bufs()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(b) then
        attach_ts(b)
      end
    end
  end

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    desc = 'Enable treesitter highlighting and indentation',
    callback = function(event)
      attach_ts(event.buf)
    end,
  })

  vim.schedule(reattach_all_bufs)

  -- Async install (no :wait): Neovim stays responsive; highlights may appear after parsers land.
  -- Set `vim.g.user_ts_notify_install = true` for a completion toast on every run (noisy if all cached).
  local install_task = ts.install(ensure_parsers, { max_jobs = 8, summary = true })
  install_task:await(function(err, ok)
    vim.schedule(function()
      if err then
        vim.notify('nvim-treesitter: ' .. tostring(err), vim.log.levels.WARN)
        reattach_all_bufs()
        return
      end
      if ok == false then
        vim.notify(
          'nvim-treesitter: one or more parsers failed (see :messages / plugin log).',
          vim.log.levels.WARN
        )
      elseif vim.g.user_ts_notify_install then
        vim.notify('nvim-treesitter: parser install finished.', vim.log.levels.INFO)
      end
      reattach_all_bufs()
    end)
  end)

  vim.g.no_plugin_maps = true

  local select = require('nvim-treesitter-textobjects.select')
  local swap = require('nvim-treesitter-textobjects.swap')
  local move = require('nvim-treesitter-textobjects.move')

  keymap.set({ 'x', 'o' }, 'af', function()
    select.select_textobject('@function.outer', 'textobjects')
  end)
  keymap.set({ 'x', 'o' }, 'if', function()
    select.select_textobject('@function.inner', 'textobjects')
  end)
  keymap.set({ 'x', 'o' }, 'ac', function()
    select.select_textobject('@class.outer', 'textobjects')
  end)
  keymap.set({ 'x', 'o' }, 'ic', function()
    select.select_textobject('@class.inner', 'textobjects')
  end)

  keymap.set({ 'n', 'x', 'o' }, ']m', function()
    move.goto_next_start('@function.outer', 'textobjects')
  end, { desc = 'Next function start' })
  keymap.set({ 'n', 'x', 'o' }, ']M', function()
    move.goto_next_end('@function.outer', 'textobjects')
  end, { desc = 'Next function end' })
  keymap.set({ 'n', 'x', 'o' }, '[m', function()
    move.goto_previous_start('@function.outer', 'textobjects')
  end, { desc = 'Previous function start' })
  keymap.set({ 'n', 'x', 'o' }, '[M', function()
    move.goto_previous_end('@function.outer', 'textobjects')
  end, { desc = 'Previous function end' })

  keymap.set({ 'n', 'x', 'o' }, ']]', function()
    move.goto_next_start('@class.outer', 'textobjects')
  end, { desc = 'Next class start' })
  keymap.set({ 'n', 'x', 'o' }, '][', function()
    move.goto_next_end('@class.outer', 'textobjects')
  end, { desc = 'Next class end' })
  keymap.set({ 'n', 'x', 'o' }, '[[', function()
    move.goto_previous_start('@class.outer', 'textobjects')
  end, { desc = 'Previous class start' })
  keymap.set({ 'n', 'x', 'o' }, '[]', function()
    move.goto_previous_end('@class.outer', 'textobjects')
  end, { desc = 'Previous class end' })

  keymap.set('n', '<leader>cs', function()
    swap.swap_next('@parameter.inner')
  end, { desc = 'Swap next parameter' })
  keymap.set('n', '<leader>cS', function()
    swap.swap_previous('@parameter.inner')
  end, { desc = 'Swap previous parameter' })

  require('treesj').setup({
    max_join_length = 2000,
    use_default_keymaps = false,
  })
  keymap.set('n', 'gS', function()
    require('treesj').toggle()
  end, { desc = 'Split or Join code block with autodetect' })

  require('refactoring').setup()
end

return M
