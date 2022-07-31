# vim: foldmethod=marker
# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options. This allows you to apply configuration changes without
  # restarting zsh. Edit ~/.p10k.zsh and type `source ~/.p10k.zsh`.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  autoload -Uz is-at-least && is-at-least 5.1 || return

  # Prompt colors. {{{1
  local black=0
  local maroon=1
  local green=2
  local olive=3
  local navy=4
  local purple=5
  local teal=6
  local silver=7
  local grey=8
  local red=9
  local lime=10
  local yellow=11
  local blue=12
  local fuchsia=13
  local aqua=14
  local white=15

  # left prompt {{{1
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]========================= 
    context                 # user@hostname
    form3_shell             # f3 shell indicator
    shell_level             # show the subshell level - SHLVL
    vim_shell               # vim shell indicator (:sh)
    dir                     # current directory
    vcs                     # git status
    # =========================[ Line #2 ]=========================
    newline                 # \n
    prompt_char             # prompt symbol
  )

  # right prompt {{{1
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    background_jobs         # presence of background jobs
    load                    # CPU load
    nvm                     # node.js version from nvm (https://github.com/nvm-sh/nvm)
    go_version              # go version (https://golang.org)
    java_version            # java version (https://www.java.com/)
    kubecontext             # current kubernetes context (https://kubernetes.io/)
    aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
    public_ip               # public IP address
    vpn_ip                  # virtual private network indicator
    time                    # current time
    # =========================[ Line #2 ]=========================
    newline
  )

  # base config {{{1
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=none
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=''
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=
  if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=242
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
    typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
  fi

  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0B5'
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='\uE0B7'
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B4'
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0B6'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B4'
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B6'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B6'
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B4'
  typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  # prompt_char {{{1
  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=$grey
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$lime
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$red
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='Ⅴ'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B4'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B6'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_{LEFT,RIGHT}_WHITESPACE=''

  # context {{{1
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

  # dir {{{1
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=$blue
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  local anchor_files=(
    .bzr
    .citc
    .git
    .hg
    .node-version
    .python-version
    .go-version
    .ruby-version
    .lua-version
    .java-version
    .perl-version
    .php-version
    .tool-version
    .shorten_folder_marker
    .svn
    .terraform
    CVS
    Cargo.toml
    composer.json
    go.mod
    package.json
    stack.yaml
  )
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3
  typeset -g POWERLEVEL9K_DIR_CLASSES=()

  # vcs/git {{{1
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  # git formatter {{{2
  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    local       meta='%8F'   # grey foreground
    local      clean='%0F'   # lime foreground
    local   modified='%0F'   # yellow foreground
    local  untracked='%0F'   # blue foreground
    local conflicted='%1F'   # red foreground

    local res

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      (( $#branch > 32 )) && branch[13,-13]="…"  # <-- this line
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    fi

    if [[ -n $VCS_STATUS_TAG
          && -z $VCS_STATUS_LOCAL_BRANCH  # <-- this line
        ]]; then
      local tag=${(V)VCS_STATUS_TAG}
      (( $#tag > 32 )) && tag[13,-13]="…"  # <-- this line
      res+="${meta}#${clean}${tag//\%/%%}"
    fi
    (( $#where > 32 )) && where[13,-13]="…"
    res+="${clean}${where//\%/%%}"  # escape %

    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&  # <-- this line
      res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
    fi

    if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
      res+=" ${modified}wip"
    fi

    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
    (( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

    typeset -g my_git_format=$res
  }
  # }}}
  functions -M my_git_formatter 2>/dev/null

  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter()))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  # status {{{1
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=true
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=$green

  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_BACKGROUND=$green

  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=$red

  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND=$red

  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_BACKGROUND=$red

  # command_execution_time {{{1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$white
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=$grey
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=

  # background_jobs {{{1
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$aqua
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=$grey
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true

  # vim_shell {{{1
  typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_VIM_SHELL_BACKGROUND=$green

  # load {{{1
  typeset -g POWERLEVEL9K_LOAD_WHICH=1
  typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_LOAD_NORMAL_BACKGROUND=$lime
  typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_LOAD_WARNING_BACKGROUND=$yellow
  typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND=$red

  # nvm {{{1
  typeset -g POWERLEVEL9K_NVM_FOREGROUND=$magenta
  typeset -g POWERLEVEL9K_NVM_BACKGROUND=$grey
  typeset -g POWERLEVEL9K_NVM_PROJECT_ONLY=false
  typeset -g POWERLEVEL9K_NVM_SHOW_ON_COMMAND='nvm|npm|node'

  # go_version {{{1
  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=$aqua
  typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND=$grey
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=false
  typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='ﳑ'
  typeset -g POWERLEVEL9K_GO_VERSION_SHOW_ON_COMMAND='go'

  # java_version {{{1
  typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=$olive
  typeset -g POWERLEVEL9K_JAVA_VERSION_BACKGROUND=$grey
  typeset -g POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=false
  typeset -g POWERLEVEL9K_JAVA_VERSION_FULL=false
  typeset -g POWERLEVEL9K_JAVA_VERSION_SHOW_ON_COMMAND='java|javac|gradle|gradlew'

  # kubecontext {{{1
  typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|flux|fluxctl|stern|minikube|skaffold'
  typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
      '*'       DEFAULT)
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=$purple
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_BACKGROUND=$grey
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION=
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${P9K_KUBECONTEXT_CLOUD_CLUSTER:-${P9K_KUBECONTEXT_NAME}}'
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'

  # aws {{{1
  typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|awless|terraform|pulumi|terragrunt|f3'
  typeset -g POWERLEVEL9K_AWS_CLASSES=(
      '*'       DEFAULT)
  typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_AWS_DEFAULT_BACKGROUND=$yellow
  typeset -g POWERLEVEL9K_AWS_CONTENT_EXPANSION='${P9K_AWS_PROFILE//\%/%%}${P9K_AWS_REGION:+ ${P9K_AWS_REGION//\%/%%}}'

  # ip {{{1
  typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_PUBLIC_IP_BACKGROUND=$navy
  typeset -g POWERLEVEL9K_PUBLIC_IP_SHOW_ON_COMMAND='f3|ip'

  # vpn_ip {{{1
  typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND=$grey
  typeset -g POWERLEVEL9K_VPN_IP_BACKGROUND=$navy
  typeset -g POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION=
  typeset -g POWERLEVEL9K_VPN_IP_INTERFACE='gpd|wg|(.*proton)|(.*tun)|tailscale)[0-9]*'
  typeset -g POWERLEVEL9K_VPN_IP_SHOW_ALL=false

  # time {{{1
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$white
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=$grey
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=

  # form3_shell {{{1
  typeset -g POWERLEVEL9K_FORM3_SHELL_BACKGROUND=$grey

  function prompt_form3_shell() {
    local session_expiry
    if (( ${+F3_SESS_EXPIRY} )); then
        session_expiry="${F3_SESS_EXPIRY}"
    else
        local info
        info="$(f3 auth info --json 2>/dev/null)"
        if [[ $? -ne 0 ]]; then
            return
        fi

        session_expiry="$(echo "${info}" | jq -r .expiry 2>/dev/null)"
    fi

    if (( ${session_expiry} )); then
      local total=$((session_expiry - $(date +%s)))
      local mins=$((total / 60))
      local color="$(_minutes_to_hex $mins)"
      local text=$'\uf415 '${mins}m
      p10k segment -f ${color} -t ${text}
    fi
  }

  function instant_prompt_form3_shell() {
    prompt_form3_shell
  }

  # shell_level {{{1
  typeset -g POWERLEVEL9K_SHELL_LEVEL_SHOW_ONE=false
  typeset -g POWERLEVEL9K_SHELL_LEVEL_FOREGROUND=$purple
  typeset -g POWERLEVEL9K_SHELL_LEVEL_BACKGROUND=$grey

  function prompt_shell_level() {
    local one=0xf8a3
    local nine_plus=0xf8be
    local code="${one}"

    (( code = one + (SHLVL - 1) * 3 ))
    code=$(( code > nine_plus ? nine_plus : code ))

    [[ ${code} -eq ${one} && "${POWERLEVEL9K_SHELL_LEVEL_SHOW_ONE}" = false ]] && return

    local icon=$(printf '%b' "\U$(printf '%x' "$code")")

    p10k segment -i ${icon}
  }

  function instant_prompt_shel_level() {
    prompt_shell_level
  }

  # transient prompt {{{1
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

  # instant prompt {{{1
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # hot reload {{{1
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # If p10k is already loaded, reload configuration.
  # This works even with POWERLEVEL9K_DISABLE_HOT_RELOAD=true.
  (( ! $+functions[p10k] )) || p10k reload
}

# }}}

# Tell `p10k configure` which file it should overwrite.
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
