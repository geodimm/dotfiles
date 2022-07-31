# vim: foldmethod=marker
# left prompt {{{1
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  # line 1 {{{2
  context                 # user@hostname
  form3_shell             # f3 shell indicator
  shell_level             # show the subshell level - SHLVL
  vim_shell               # vim shell indicator (:sh)
  dir                     # current directory
  vcs                     # git status
  # line 2 {{{2
  newline                 # \n
  prompt_char             # prompt symbol
)

# right prompt {{{1
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  # line 1 {{{2
  status                  # exit code of the last command
  command_execution_time  # duration of the last command
  background_jobs         # presence of background jobs
  load                    # CPU load
  time                    # current time
  # line 2 {{{2
  newline
  nvm                     # node.js version from nvm (https://github.com/nvm-sh/nvm)
  go_version              # go version (https://golang.org)
  java_version            # java version (https://www.java.com/)
  kubecontext             # current kubernetes context (https://kubernetes.io/)
  aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
  public_ip               # public IP address
  vpn_ip                  # virtual private network indicator
)
# }}}

typeset -g POWERLEVEL9K_MODE=nerdfont-complete
typeset -g POWERLEVEL9K_ICON_PADDING=none
typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0B5'
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='\uE0B7'
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B4'
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0B6'
typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B4'
typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B6'
typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B6'
typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B4'
typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
