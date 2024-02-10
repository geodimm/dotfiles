# vim: foldmethod=marker
typeset -g POWERLEVEL9K_FORM3_SHELL_BACKGROUND=$black

function prompt_form3_shell() {
    local session_file="${HOME}/.f3session"
    local output
    if find ${session_file} -mmin -5 2>/dev/null| grep -q "."; then
        output="$(cat ${session_file})"
    else
        output="$(f3 auth info --json 2>/dev/null | tee ${session_file})"
    fi

    local session_expiry="$(echo ${output} | jq -Rr 'fromjson? | .expiry' 2>/dev/null)"
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
