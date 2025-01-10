-- vim: foldmethod=marker

local keymap = require('utils.keymap')

-- Show current line in GitHub {{{1
local function trim_space(s)
  return string.gsub(s, '%s+$', '')
end

local function get_github_repo()
  local url = trim_space(vim.fn.system('git config --get remote.origin.url'))
  if string.find(url, '^git@') then
    local parts = {}
    for part in string.gmatch(url, '([^:]+)') do
      table.insert(parts, part)
    end

    url = 'https://github.com/' .. parts[2]
  end

  return string.gsub(url, '.git$', '')
end

local function get_main_branch()
  local result = trim_space(vim.fn.system('git symbolic-ref HEAD'))
  local parts = {}
  for part in string.gmatch(result, '([^/]+)') do
    table.insert(parts, part)
  end

  return parts[#parts]
end

local function generate_github_link()
  local repo_root = vim.fs.root(0, '.git')
  local repo = get_github_repo()
  local branch = get_main_branch()
  local path = string.sub(vim.fn.expand('%:p'), string.len(repo_root .. '/') + 1)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local url = string.format('%s/blob/%s/%s?plain=1#L%s', repo, branch, path, cursor_pos[1])
  return url
end

local function open_program()
  local platform = trim_space(vim.fn.system('uname'))
  local exe = 'xdg-open'
  if platform == 'Darwin' then
    exe = 'open'
  end
  return exe
end

local function open_in_github()
  local url = generate_github_link()
  local open = open_program()
  os.execute(string.format('%s "%s" >/dev/null 2>&1', open, url))
end

vim.api.nvim_create_user_command('ShowInGitHub', open_in_github, { nargs = 0 })

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
