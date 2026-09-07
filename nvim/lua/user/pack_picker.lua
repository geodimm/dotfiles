local M = {}

local function git(path, args, done)
  local command = { 'git', '-C', path }
  vim.list_extend(command, args)
  vim.system(
    command,
    { text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        done(nil, vim.trim(result.stderr or 'git command failed'))
        return
      end
      done(vim.trim(result.stdout or ''))
    end)
  )
end

local function resolve_target(plugin, done)
  local version = plugin.spec.version
  local function resolve_revision(target_ref, version_label)
    git(plugin.path, { 'rev-list', '-1', target_ref }, function(target, err)
      done(target, version_label, err)
    end)
  end

  if version == nil then
    git(plugin.path, { 'rev-parse', '--abbrev-ref', 'origin/HEAD' }, function(default_ref, err)
      if not default_ref then
        done(nil, nil, err)
        return
      end
      resolve_revision(default_ref, default_ref:gsub('^origin/', ''))
    end)
  elseif type(version) == 'string' then
    git(plugin.path, {
      'show-ref',
      '--verify',
      '--quiet',
      'refs/remotes/origin/' .. version,
    }, function(_, branch_err)
      resolve_revision(branch_err and version or 'origin/' .. version, version)
    end)
  else
    git(plugin.path, { 'tag', '--list' }, function(output, err)
      if not output then
        done(nil, nil, err)
        return
      end

      local best_tag
      local best_version
      for tag in vim.gsplit(output, '\n', { plain = true, trimempty = true }) do
        local parsed = vim.version.parse(tag, { strict = true })
        if parsed and version:has(parsed) and (not best_version or vim.version.gt(parsed, best_version)) then
          best_tag = tag
          best_version = parsed
        end
      end
      if not best_tag then
        done(nil, nil, 'no tag matches ' .. tostring(version))
        return
      end
      resolve_revision(best_tag, best_tag)
    end)
  end
end

local function inspect_plugin(plugin, done)
  git(plugin.path, { 'rev-list', '-1', 'HEAD' }, function(current, current_error)
    local item = {
      active = plugin.active,
      current = current or plugin.rev,
      name = plugin.spec.name,
      path = plugin.path,
      source = plugin.spec.src,
    }

    if current_error then
      item.status = 'error'
      item.error = current_error:match('[^\n]+')
      done(item)
      return
    end
    if not plugin.active then
      item.status = 'clean'
      done(item)
      return
    end

    git(plugin.path, {
      'fetch',
      '--quiet',
      '--tags',
      '--force',
      '--recurse-submodules=yes',
      'origin',
    }, function(_, fetch_error)
      if fetch_error then
        item.status = 'error'
        item.error = fetch_error:match('[^\n]+')
        done(item)
        return
      end

      resolve_target(plugin, function(target, version, err)
        if not target then
          item.status = 'error'
          item.error = err and err:match('[^\n]+') or 'could not resolve target'
          done(item)
          return
        end

        item.target = target
        item.version = version
        item.status = target == item.current and 'current' or 'update'
        if item.status ~= 'update' then
          done(item)
          return
        end

        git(plugin.path, { 'rev-list', '--count', item.current .. '..' .. target }, function(commits)
          item.commits = tonumber(commits) or 0
          done(item)
        end)
      end)
    end)
  end)
end

local function selected_names(selected)
  local names = {}
  local seen = {}
  for _, line in ipairs(selected) do
    local name = line:match('^([^\t]+)')
    if name and not seen[name] then
      names[#names + 1] = name
      seen[name] = true
    end
  end
  return names
end

local function short_revision(revision)
  return revision and revision:sub(1, 8) or '--------'
end

local function entry_formatter(plugins)
  local fzf_utils = require('fzf-lua.utils')
  local ansi = fzf_utils.ansi_codes
  local icons = require('user.icons')
  local max_name = 0
  for _, plugin in ipairs(plugins) do
    max_name = math.max(max_name, vim.api.nvim_strwidth(plugin.spec.name))
  end

  local styles = {
    update = { color = ansi.yellow, icon = icons.ui.exclamation, label = 'UPDATE' },
    clean = { color = ansi.red, icon = icons.git.status.deleted, label = 'CLEAN' },
    current = { color = ansi.green, icon = icons.ui.check, label = 'CURRENT' },
    error = { color = ansi.red, icon = icons.ui.times, label = 'ERROR' },
  }
  return function(item)
    local style = styles[item.status]
    local badge = style.color(('%s  %-7s'):format(style.icon, style.label))
    local name = ansi.cyan(item.name .. (' '):rep(max_name - vim.api.nvim_strwidth(item.name)))
    local detail
    if item.status == 'update' then
      detail = ('%s  →  %s  %s · %d commit%s'):format(
        short_revision(item.current),
        short_revision(item.target),
        item.version,
        item.commits,
        item.commits == 1 and '' or 's'
      )
    elseif item.status == 'clean' then
      detail = short_revision(item.current) .. '  not in current config'
    elseif item.status == 'error' then
      detail = item.error or 'unknown error'
    else
      detail = short_revision(item.current) .. '  ' .. (item.version or '')
    end
    local visible = table.concat({ badge, name, detail }, '  ')
    local preview_ref = item.status == 'update' and (item.current .. '..' .. item.target) or '-8'
    return table.concat({ item.name, item.path, preview_ref, visible }, '\t')
  end
end

local function open_picker(plugins)
  local by_name = {}
  local format_entry = entry_formatter(plugins)
  local fzf = require('fzf-lua')
  local function updatable_names(selected)
    return vim
      .iter(selected and selected_names(selected) or vim.tbl_keys(by_name))
      :filter(function(name)
        local item = by_name[name]
        return item.active and item.status ~= 'error'
      end)
      :totable()
  end

  local contents = function(fzf_cb)
    local pending = #plugins
    if pending == 0 then
      M.checking = false
      fzf_cb()
      return
    end

    for _, plugin in ipairs(plugins) do
      inspect_plugin(plugin, function(item)
        by_name[item.name] = item
        fzf_cb(format_entry(item))
        pending = pending - 1
        if pending == 0 then
          M.checking = false
          fzf_cb()
        end
      end)
    end
  end

  fzf.fzf_exec(contents, {
    prompt = ' Packages > ',
    preview = [[
      printf '\033[1;36m%s\033[0m\n' {1}
      git -C {2} remote get-url origin
      printf '\n'
      git -C {2} --no-pager log --color=always --decorate --oneline {3}
    ]],
    actions = {
      enter = {
        desc = 'update selected',
        header = 'update selected',
        fn = function(selected)
          local names = updatable_names(selected)
          if #names == 0 then
            vim.notify('Select active plugins with a successful update check', vim.log.levels.WARN)
            return
          end
          vim.pack.update(names, { offline = true })
        end,
      },
      ['ctrl-u'] = {
        desc = 'update all',
        header = 'update all',
        fn = function()
          vim.pack.update(updatable_names(), { offline = true })
        end,
      },
      ['ctrl-x'] = {
        desc = 'clean',
        header = 'clean',
        fn = function()
          vim.cmd.PackClean()
        end,
      },
      ['ctrl-r'] = {
        desc = 'refresh',
        header = 'refresh',
        fn = function()
          vim.schedule(M.open)
        end,
      },
      ['ctrl-o'] = {
        desc = 'open source',
        header = 'open source',
        fn = function(selected)
          local name = selected_names(selected)[1]
          if name then
            vim.ui.open(by_name[name].source)
          end
        end,
      },
    },
    _headers = { 'actions' },
    header_prefix = ('Checking %d plugins asynchronously…\n'):format(#plugins),
    header_separator = '  ·  ',
    fzf_opts = {
      ['--ansi'] = true,
      ['--delimiter'] = '\t',
      ['--multi'] = true,
      ['--no-sort'] = true,
      ['--with-nth'] = '4..',
    },
    winopts = {
      title = ' Plugin Control ',
    },
    silent = true,
  })
end

function M.open()
  if M.checking then
    vim.notify('Plugin update check is already running', vim.log.levels.WARN)
    return
  end
  M.checking = true
  local ok, err = xpcall(function()
    open_picker(vim.pack.get(nil, { info = false }))
  end, debug.traceback)
  if not ok then
    M.checking = false
    vim.notify(err, vim.log.levels.ERROR)
  end
end

return M
