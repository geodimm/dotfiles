local M = {}

M.ui = {
  prompt = '', -- nf-fa-chevron_right
  search = '', -- nf-fa-search
  list_ul = '', -- nf-fa-list-ul
  gear = '', -- nf-fa-gear
  gears = '', --nf-fa-gears
  lightbulb = '', -- nf-cod-lightbulb
  lock = '', -- nf-fa-lock
  tree = '', -- nf-fa-tree
  scissors = '', -- nf-fa-scissors
  calendar = '', -- nf-fa-calendar
  pencil = '', -- nf-fa-pencil
  bug = '', -- nf-fa-bug
  plug = '', -- nf-fa-plug
  update = '󰚰', -- nf-md-update
  location = '', -- nf-oct-location
  breadcrumb = '󰄾', -- nf-md-chevron_double_right
  exit = '󰗼', -- nf-md-exit_to_app
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
}

M.ui.close = M.ui.error

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
  repository = '󰳏', -- nf-md-source_repository
  repositories = '󰳐', -- nf-md-source_repository_multiple
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
    added = M.ui.plus,
    ignored = M.ui.times,
    modified = M.ui.exclamation,
    removed = M.ui.minus,
    renamed = M.ui.arrow_right,
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
