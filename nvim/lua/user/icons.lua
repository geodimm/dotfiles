local M = {}

M.ui = {
  prompt = '', -- nf-fa-chevron_right
  search = '', -- nf-fa-search
  list_ul = '', -- nf-fa-list-ul
  gear = '', --nf-fa-gear
  lightbulb = '', -- nf-cod-lightbulb
  tree = '', -- nf-fa-tree
  calendar = '', -- nf-fa-calendar
  pencil = '', -- nf-fa-pencil
  bug = '', -- nf-fa-bug
  plug = '', -- nf-fa-plug
  update = '󰚰', -- nf-md-update
  breadcrumb = '󰄾', -- nf-md-chevron_double_right
  sign_out = '', -- nf-fa-sign_out
  check = '', -- nf-fa-check_circle
  play = '', -- nf-fa-play_circle
  plus = '', -- nf-fa-plus_circle
  minus = '', -- nf-fa-minus_circle
  times = '', -- nf-fa-times_circle
  arrow_right = '', -- nf-fa-arrow_circle_right
  info = '', -- nf-fa-info_circle
  exclamation = '', -- nf-fa-exclamation_circle
  question = '', -- nf-fa-question_circle
  location = '', -- nf-cod-location
}

M.os = {
  unix = '', -- nf-fa-linux
  dos = '', -- nf-fa-windows
  mac = '', -- nf-fa-apple
}

M.keyboard = {
  Alt = '󰘵', -- nf-md-apple_keyboard_option
  Backspace = '󰌍', -- nf-md-keyboard_return
  Caps = '󰘲', -- nf-md-apple_keyboard_caps
  Control = '󰘴', -- nf-md-apple_keyboard_control
  Return = '󰌑', -- nf-md-keyboard_return
  Shift = '󰘶', -- nf-md-apple_keyboard_shift
  Space = '󱁐', --nf-md-keyboard-space
  Tab = '󰌒', -- nf-md-keyboard_tab
}

M.file = {
  newfile = '󰈔', -- nf-md-file
  readonly = '󰈡', -- nf-md-file_lock
  modified = '󰝒', -- nf-md-file_plus
  unnamed = '󰡯', -- nf-md-file_question
  find = '󰈞', -- nf-md-file_find
  directory = '󰉋', -- nf-md-folder
}

M.git = {
  repositories = '󰳐', -- nf-md-source_repository_multiple
  branch = '', -- nf-dev-git_branch
  compare = '', -- nf-dev-git_compare
  merge = '', -- nf-dev-git_merge
  diff = {
    diff = '', -- nf-oct-diff
    added = M.ui.plus,
    ignored = M.ui.times,
    modified = M.ui.exclamation,
    removed = M.ui.minus,
    renamed = M.ui.arrow_right,
  },
}

M.powerline = {
  left_half_circle_thick = '', -- nf-ple-left_half_circle_thick
  right_half_circle_thick = '', -- nf-ple-right_half_circle_thick
}

M.lsp = {
  error = M.ui.times,
  hint = M.ui.lightbulb,
  info = M.ui.info,
  other = M.ui.question,
  warn = M.ui.exclamation,
}

M.lsp_progress = {
  [0] = '', -- nf-fa-circle_o
  [1] = '󰪞', -- nf-md-circle_slice_1
  [2] = '󰪟', -- nf-md-circle_slice_2
  [3] = '󰪟', -- nf-md-circle_slice_2
  [4] = '󰪠', -- nf-md-circle_slice_3
  [5] = '󰪡', -- nf-md-circle_slice_4
  [6] = '󰪢', -- nf-md-circle_slice_5
  [7] = '󰪣', -- nf-md-circle_slice_6
  [8] = '󰪤', -- nf-md-circle_slice_7
  [9] = '󰪤', -- nf-md-circle_slice_7
  [10] = '󰪥', -- nf-md-circle_slice_8
}

M.lspconfig = {
  Error = M.lsp.error,
  Hint = M.lsp.hint,
  Info = M.lsp.info,
  Other = M.lsp.other,
  Warn = M.lsp.warn,
}

M.dap = {
  DapBreakpoint = '', -- nf-cod-debug
  DapBreakpointCondition = '', -- nf-cod-debug_breakpoint_conditional
  DapBreakpointRejected = '', -- nf-cod-debug_breakpoint_unsupported
  DapLogPoint = '', -- nf-cod-debug_breakpoint_log
  DapStopped = '', -- nf-cod-debug_continue
}

M.nerdtree = {
  error = M.lsp.error,
  hint = M.lsp.hint,
  info = M.lsp.info,
  warning = M.lsp.warn,
}

M.telescope = {
  prompt_prefix = M.ui.search .. ' ',
  selection_caret = M.ui.prompt .. ' ',
}

return M
