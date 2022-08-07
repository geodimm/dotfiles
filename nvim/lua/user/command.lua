-- vim: foldmethod=marker

local keymaps = require('user.keymaps')

-- Show current line in GitHub {{{1
local trim_space = function(s)
  return string.gsub(s, '%s+$', '')
end

local get_github_repo = function()
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

local get_main_branch = function()
  for branch in pairs({ 'master', 'main' }) do
    local result = os.execute('git show-ref --quiet refs/heads/' .. branch)
    if not result then
      return branch
    end
  end

  return 'master'
end

local generate_github_link = function()
  local repo_root = trim_space(vim.fn.system('git rev-parse --show-toplevel'))
  local repo = get_github_repo()
  local branch = get_main_branch()
  local path = string.sub(vim.fn.expand('%:p'), string.len(repo_root .. '/') + 1)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local url = string.format('%s/blob/%s/%s?plain=1#L%s', repo, branch, path, cursor_pos[1])
  return url
end

local open_in_github = function()
  local url = generate_github_link()
  os.execute(string.format('xdg-open "%s"', url))
end

vim.api.nvim_create_user_command('ShowInGitHub', open_in_github, { nargs = 0 })

keymaps.set('n', '<leader>gg', '<cmd>ShowInGitHub<CR>', { desc = 'Show in GitHub', silent = true })

-- Close all buffers except the current one {{{1
vim.api.nvim_create_user_command('BufOnly', 'silent! execute "%bd|e#|bd#"', { nargs = 0 })

keymaps.set('n', '<leader>b', ':BufOnly<CR>', { desc = 'Close all other buffers' })
-- }}}
