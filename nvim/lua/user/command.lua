-- vim: foldmethod=marker

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

-- Change directory to the .git root of the current buffer
local function get_git_root()
  local dot_git_path = vim.fn.finddir('.git', '.;')
  return vim.fn.fnamemodify(dot_git_path, ':h')
end

vim.api.nvim_create_user_command('CdGitRoot', function()
  local dir = get_git_root()
  vim.api.nvim_set_current_dir(dir)
  vim.notify(string.format('Changed current directory to %s', dir), vim.log.levels.INFO)
end, {})
