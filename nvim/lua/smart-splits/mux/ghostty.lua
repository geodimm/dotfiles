-- Ghostty mux for smart-splits.nvim (not upstream; macOS AppleScript, 1.3+).
-- Ghostty binds performable:ctrl+hjkl=goto_split so TUIs (cursor-agent) can
-- leave a pane. This surface activates the `nvim` key table so those keys
-- reach Neovim first (vsplits, then AppleScript at a true nvim edge).
local utils = require('smart-splits.utils')

local M = {}
M.type = 'ghostty'

local dir_keys = {
  left = 'h',
  right = 'l',
  up = 'k',
  down = 'j',
}

local function osascript(lines)
  local cmd = { 'osascript' }
  for _, line in ipairs(lines) do
    table.insert(cmd, '-e')
    table.insert(cmd, line)
  end
  local output, code = utils.system(cmd)
  if code ~= 0 then
    return nil, code
  end
  return vim.trim(output or ''), code
end

local function focused_terminal_id()
  local id = osascript({
    'tell application "Ghostty"',
    '  id of focused terminal of selected tab of front window',
    'end tell',
  })
  if not id or id == '' then
    return nil
  end
  return id
end

local function perform(action)
  local result, code = osascript({
    'tell application "Ghostty"',
    '  set t to focused terminal of selected tab of front window',
    string.format('  perform action "%s" on t', action),
    'end tell',
  })
  return code == 0, result
end

-- Ghostty key table that sends ctrl+hjkl through to Neovim (see ghostty/config).
local NVIM_KEY_TABLE = 'nvim'

function M.claim_keys()
  perform('activate_key_table:' .. NVIM_KEY_TABLE)
end

function M.release_keys()
  perform('deactivate_all_key_tables')
end

---Sidebars (snacks, etc.) are floats with zindex < 50.
local function is_nav_window(win)
  if not vim.api.nvim_win_is_valid(win) then
    return false
  end
  local cfg = vim.api.nvim_win_get_config(win)
  if cfg.relative == '' then
    return true
  end
  return cfg.zindex ~= nil and cfg.zindex < 50
end

---@param direction 'left'|'right'|'up'|'down'
---@return integer|nil
function M.neighbor_win(direction)
  local key = dir_keys[direction]
  if not key then
    return nil
  end

  local cur = vim.api.nvim_get_current_win()
  local dest_nr = vim.fn.winnr(key)
  if dest_nr ~= vim.fn.winnr() then
    local id = vim.fn.win_getid(dest_nr)
    if id ~= 0 and id ~= cur then
      return id
    end
  end

  local cpos = vim.api.nvim_win_get_position(cur)
  local crow, ccol = cpos[1], cpos[2]
  local cw = vim.api.nvim_win_get_width(cur)
  local ch = vim.api.nvim_win_get_height(cur)
  local cbottom, cright = crow + ch, ccol + cw

  local best, best_dist = nil, math.huge
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= cur and is_nav_window(win) then
      local p = vim.api.nvim_win_get_position(win)
      local w = vim.api.nvim_win_get_width(win)
      local h = vim.api.nvim_win_get_height(win)
      local bottom, right = p[1] + h, p[2] + w
      local overlap_v = p[1] < cbottom and crow < bottom
      local overlap_h = p[2] < cright and ccol < right
      local dist
      if direction == 'right' and overlap_v and p[2] >= cright - 1 then
        dist = p[2] - cright
      elseif direction == 'left' and overlap_v and right <= ccol + 1 then
        dist = ccol - right
      elseif direction == 'down' and overlap_h and p[1] >= cbottom - 1 then
        dist = p[1] - cbottom
      elseif direction == 'up' and overlap_h and bottom <= crow + 1 then
        dist = crow - bottom
      end
      if dist and dist < best_dist then
        best, best_dist = win, dist
      end
    end
  end
  return best
end

---wincmd first; leave Neovim only when no window exists in that direction.
function M.move(direction)
  local win = M.neighbor_win(direction)
  if win then
    if vim.fn.mode() == 't' then
      vim.cmd('stopinsert')
    end
    vim.api.nvim_set_current_win(win)
    return true
  end
  if not M.is_in_session() then
    return false
  end
  return perform('goto_split:' .. direction)
end

function M.current_pane_id()
  return focused_terminal_id()
end

function M.current_pane_at_edge()
  return false
end

function M.is_in_session()
  return vim.env.TERM_PROGRAM == 'ghostty' and vim.fn.has('macunix') == 1
end

function M.current_pane_is_zoomed()
  return false
end

function M.next_pane(direction)
  if not M.is_in_session() then
    return false
  end
  -- Never AppleScript past an nvim vsplit, even if smart-splits says wrap.
  if M.neighbor_win(direction) then
    return false
  end
  return perform('goto_split:' .. direction)
end

function M.resize_pane(direction, amount)
  if not M.is_in_session() then
    return false
  end
  -- Ghostty resize is pixels; smart-splits default_amount is cells (~3).
  local px = math.max(10, (amount or 3) * 10)
  return perform(string.format('resize_split:%s,%d', direction, px))
end

function M.split_pane(direction, _)
  if not M.is_in_session() then
    return false
  end
  local _, code = osascript({
    'tell application "Ghostty"',
    '  set t to focused terminal of selected tab of front window',
    string.format('  split t direction %s', direction),
    'end tell',
  })
  return code == 0
end

function M.update_mux_layout_details() end

return M
