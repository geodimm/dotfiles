local M = {}

M.ui = {
  list_ul = '', -- nf-fa-list-ul
  lightbulb = '', -- nf-cod-lightbulb
  tree = '', -- nf-fa-tree
  pencil = '', -- nf-fa-pencil
  breadcrumb = '󰄾', -- nf-md-chevron_double_right
  check = '', -- nf-fa-check_circle
  play = '', -- nf-fa-play_circle
  times = '', -- nf-fa-times_circle
  arrow_right = '', -- nf-fa-arrow_circle_right
  info = '', -- nf-fa-info_circle
  exclamation = '', -- nf-fa-exclamation_circle
  question = '', -- nf-fa-question_circle
  keyboard = '', -- nf-fa-keyboard
  plug = '', -- nf-fa-plug
  history = '', -- nf-fa-history
  code_braces = '󰅩', -- nf-md-code_braces
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
  directory_open = '󰝰', -- nf-md-folder_open
}

M.git = {
  branch = '', -- nf-oct-git_branch
  compare = '', -- nf-oct-git_compare
  status = {
    modified = '', -- nf-oct-diff_modified
    filetype_changed = '', -- nf-oct-file-diff
    added = '', -- nf-oct-diff_added
    deleted = '', -- nf-oct-diff_removed
    renamed = '', -- nf-oct-diff_renamed
    copied = '', -- nf-oct-copy
    unmerged = '', -- nf-oct-diff_modified
    untracked = '', -- nf-oct-question
    ignored = '', -- nf-oct-diff_ignored
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

M.nerdtree = {
  error = M.lsp.error,
  hint = M.lsp.hint,
  info = M.lsp.info,
  warning = M.lsp.warn,
}

return M
