-- vim: foldmethod=marker

local keymap = require('utils.keymap')

-- Close all buffers except the current one {{{1
vim.api.nvim_create_user_command('BufOnly', 'silent! execute "%bd|e#|bd#"', { nargs = 0 })

-- Change directory to the .git root of the current buffer {{{1
local function get_git_root()
  local dot_git_path = vim.fn.finddir('.git', '.;')
  return vim.fn.fnamemodify(dot_git_path, ':h')
end

vim.api.nvim_create_user_command('CdGitRoot', function()
  local dir = get_git_root()
  vim.api.nvim_set_current_dir(dir)
  vim.notify(string.format('Changed current directory to %s', dir), vim.log.levels.INFO)
end, {})

-- Lookup files in other repositories {{{1
local function lookup_in_repositories()
  local status_ok, fzf = pcall(require, 'fzf-lua')
  if not status_ok then
    return
  end
  local root = vim.g.user_repos_dir or vim.fn.expand('$HOME/repos')
  local depth = vim.fs.basename(root) == 'repos' and '2' or '1'
  local _picker = 'files'
  local function toggle_action(_, opts)
    local o = vim.tbl_deep_extend('keep', { resume = true }, opts.__call_opts)
    _picker = _picker == 'files' and 'live_grep' or 'files'
    opts.__call_fn(o)
  end
  fzf.files({
    cwd = root,
    fd_opts = '--color=never --type d --follow --exclude .git --max-depth ' .. depth,
    actions = {
      ['ctrl-h'] = false,
      ['ctrl-g'] = {
        fn = toggle_action,
        desc = 'toggle-files/live_grep',
        header = function()
          return 'Use ' .. (_picker == 'files' and 'Live Grep' or 'Files')
        end,
      },
      ['default'] = {
        fn = function(selected, o)
          local file = fzf.path.entry_to_file(selected[1], o)
          local fzf_picker = _picker == 'files' and fzf.files or fzf.live_grep
          fzf_picker({
            cwd = file.path,
          })
        end,
        desc = 'lookup',
        header = function()
          return 'Open ' .. (_picker == 'files' and 'Files' or 'Live Grep')
        end,
      },
    },
    previewer = false,
    preview = {
      type = 'cmd',
      fn = function(items)
        local file = fzf.path.entry_to_file(items[1])
        return string.format('lsd --color=always --long --group-dirs first %s', vim.fs.joinpath(root, file.path))
      end,
    },
  })
end
vim.api.nvim_create_user_command('LookupInRepos', lookup_in_repositories, { nargs = 0 })
keymap.set('n', '<leader>fr', vim.cmd.LookupInRepos, { desc = 'Lookup in repositories' })

--- }}}
