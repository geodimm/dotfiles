local M = {}

M.ui = {
  prompt = '', -- nf-fa-chevron_right
  search = '', -- nf-fa-search
  list_ul = '', -- nf-fa-list-ul
  gear = '', -- nf-fa-gear
  gears = '', --nf-fa-gears
  lightbulb = '', -- nf-fa-lightbulb_o
  lock = '', -- nf-fa-lock
  tree = '', -- nf-fa-tree
  scissors = '', -- nf-fa-scissors
  calendar = '', -- nf-fa-calendar
  plug = '', -- nf-fa-plug
  update = 'ﮮ', -- nf-mdi-update
  exit = '', -- nf-mdi-exit_to_app
  sign_out = '', -- nf-fa-sign_out
  check = '', -- nf-fa-check_circle
  play = '', -- nf-fa-play_circle
  pencil = '', -- nf-fa-pencil
  bug = '', -- nf-fa-bug
  info = '', -- nf-fa-info_circle
  exclamation = '', -- nf-fa-exclamation_circle
  times = '', -- nf-fa-times_circle
  question = '', -- nf-fa-question_circle
  location = '', -- nf-oct-location
}

M.ui.close = M.ui.error

M.os = {
  unix = '', -- nf-fa-linux
  dos = '', -- nf-fa-windows
  mac = '', -- nf-fa-apple
}

M.keyboard = {
  Alt = 'הּ', -- nf-mdi-apple_keyboard_option
  Backspace = '', -- nf-mdi-keyboard_return
  Caps = 'בּ', -- nf-mdi-apple_keyboard_caps
  Control = 'דּ', -- nf-mdi-apple_keyboard_control
  Return = '', -- nf-mdi-keyboard_return
  Shift = 'וּ', -- nf-mdi-apple_keyboard_shift
  Space = '', --nf-oct-dash
  Tab = '', -- nf-mdi-keyboard_tab
}

M.file = {
  newfile = '', -- nf-mdi-file
  readonly = '', -- nf-mdi-file_lock
  modified = 'ﱐ', -- nf-mdi-file_plus
  unnamed = '', -- nf-mdi-file_outline
  find = '', -- nf-mdif-file_find
  directory = '', -- nf-mdi-folder
}

M.git = {
  git = '', -- nf-dev-git
  github = '', -- nf-dev-github_badge
  octocat = '', -- nf-dev-github_alt
  branch = '', -- nf-dev-git_branch
  commit = '', -- nf-dev-git_commit
  compare = '', -- nf-dev-git_compare
  merge = '', -- nf-dev-git_merge
  pull_request = '', -- nf-dev-git_pull_request
  diff = {
    diff = '', -- nf-oct-diff
    added = '', -- nf-oct-diff_added
    ignored = '', -- nf-oct-diff_ignored
    modified = '', -- nf-oct-diff_modified
    removed = '', -- nf-oct-diff_removed
    renamed = '', -- nf-oct-diff_renamed
  },
}

M.powerline = {
  branch = '', -- nf-pl-branch
  line_number = '', -- nf-pl-line_number
  column_number = '', -- nf-pl-columnt-number
  left_half_circle_thick = '', -- nf-ple-left_half_circle_thick
  left_half_circle_thin = '', -- nf-ple-left_half_circle_thin
  right_half_circle_thick = '', -- nf-ple-right_half_circle_thick
  right_half_circle_thin = '', -- nf-ple-right_half_circle_thin
}

M.lsp = {
  error = M.ui.times,
  hint = M.ui.lightbulb,
  info = M.ui.info,
  other = M.ui.question,
  warn = M.ui.exclamation,
}

M.lspconfig = {
  Error = M.lsp.error,
  Hint = M.lsp.hint,
  Info = M.lsp.info,
  Other = M.lsp.other,
  Warn = M.lsp.warn,
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
