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
        local path = vim.fn.shellescape(vim.fs.joinpath(root, file.path))
        return string.format('eza --color=always --long --group --group-directories-first --icons=auto --git %s', path)
      end,
    },
  })
end
vim.api.nvim_create_user_command('LookupInRepos', lookup_in_repositories, { nargs = 0 })
keymap.set('n', '<leader>fr', vim.cmd.LookupInRepos, { desc = 'Lookup in repositories' })

-- Manage plugins {{{1
local function pack_names()
  local names = vim
    .iter(vim.pack.get(nil, { info = false }))
    :map(function(plugin)
      return plugin.spec.name
    end)
    :totable()
  table.sort(names)
  return names
end

vim.api.nvim_create_user_command('PackUpdate', function(opts)
  local names = #opts.fargs > 0 and opts.fargs or nil
  vim.pack.update(names, { force = opts.bang })
end, {
  nargs = '*',
  bang = true,
  desc = 'Update all or selected plugins; ! skips review',
  complete = function(arg_lead)
    return vim
      .iter(pack_names())
      :filter(function(name)
        return vim.startswith(name, arg_lead)
      end)
      :totable()
  end,
})

vim.api.nvim_create_user_command('PackClean', function(opts)
  local unused = vim
    .iter(vim.pack.get(nil, { info = false }))
    :filter(function(plugin)
      return not plugin.active
    end)
    :map(function(plugin)
      return plugin.spec.name
    end)
    :totable()
  table.sort(unused)

  if #unused == 0 then
    vim.notify('No unused plugins', vim.log.levels.INFO)
    return
  end

  local message = ('Remove %d unused plugin(s)?\n\n%s'):format(#unused, table.concat(unused, '\n'))
  if opts.bang or vim.fn.confirm(message, '&Yes\n&No', 2) == 1 then
    vim.pack.del(unused)
    vim.notify(('Removed %d unused plugin(s)'):format(#unused), vim.log.levels.INFO)
  end
end, {
  nargs = 0,
  bang = true,
  desc = 'Remove plugins absent from the current config; ! skips confirmation',
})
--- }}}
