#! /bin/bash -e

sink="$(pactl list short sinks | grep RUNNING | cut -f1)"

cmd_opts+=("${sink}")

while getopts ":I:D:M" opt; do
    case "$opt" in
    I)
        cmd="set-sink-volume"
        cmd_opts+=("+$OPTARG%")
        ;;
    D)
        cmd="set-sink-volume"
        cmd_opts+=("-$OPTARG%")
        ;;
    M)
        cmd="set-sink-mute"
        cmd_opts+=("toggle")
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done

pactl "${cmd}" "${cmd_opts[@]}"
