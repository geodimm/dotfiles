# vim: foldmethod=marker
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
