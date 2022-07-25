local status_ok, gitsigns = pcall(require, 'gitsigns')
if not status_ok then
  return
end

gitsigns.setup({
  signs = {
    add = { text = '▌' },
    change = { text = '▌' },
    delete = { text = '▌' },
    topdelete = { text = '▌' },
    changedelete = { text = '▌' },
  },
  diff_opts = { internal = true },
  current_line_blame = true,
  current_line_blame_formatter = '  <author>, <author_time:%Y-%m-%d> - <summary>',
  preview_config = {
    border = 'rounded',
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local map = function(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

    -- Actions
    map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function()
      gs.blame_line({ full = true })
    end)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>htd', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
})

require('utils.whichkey').register({
  mappings = {
    [']c'] = { 'Next hunk' },
    ['[c'] = { 'Previous hunk' },
    ['<leader>h'] = {
      name = '+git',
      R = 'Reset buffer',
      S = 'Stage buffer',
      U = 'Reset buffer index',
      b = 'Blame line',
      d = 'Diff this',
      p = 'Preview hunk',
      r = 'Reset hunk',
      s = 'Stage hunk',
      u = 'Undo stage hunk',
      td = 'Toggle deleted',
    },
  },
  opts = {},
}, {
  mappings = {
    ['<leader>h'] = { name = '+gitsigns', r = 'reset hunk', s = 'stage hunk' },
  },
  opts = { mode = 'v' },
})
