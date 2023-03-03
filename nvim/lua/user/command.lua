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
  local result = trim_space(vim.fn.system('git symbolic-ref refs/remotes/origin/HEAD'))
  local parts = {}
  for part in string.gmatch(result, '([^/]+)') do
    table.insert(parts, part)
  end

  return parts[#parts]
end

local function generate_github_link()
  local repo_root = vim.fs.dirname(vim.fs.find('.git', { upward = true })[1])
  local repo = get_github_repo()
  local branch = get_main_branch()
  local path = string.sub(vim.fn.expand('%:p'), string.len(repo_root .. '/') + 1)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local url = string.format('%s/blob/%s/%s?plain=1#L%s', repo, branch, path, cursor_pos[1])
  return url
end

local function open_in_github()
  local url = generate_github_link()
  os.execute(string.format('xdg-open "%s" >/dev/null 2>&1', url))
end

vim.api.nvim_create_user_command('ShowInGitHub', open_in_github, { nargs = 0 })

keymap.set('n', '<leader>gg', '<cmd>ShowInGitHub<CR>', { desc = 'Show in GitHub', silent = true })

-- Close all buffers except the current one {{{1
vim.api.nvim_create_user_command('BufOnly', 'silent! execute "%bd|e#|bd#"', { nargs = 0 })

keymap.set('n', '<leader>b', ':BufOnly<CR>', { desc = 'Close all other buffers' })
-- }}}
