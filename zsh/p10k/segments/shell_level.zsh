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
