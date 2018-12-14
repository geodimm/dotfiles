#! /bin/bash -e

sink="$(pactl list short sinks | grep a2dp_sink | cut -f1)"
if [ -z "${sink}" ]; then
    sink="$(pactl list short sinks | grep analog-stereo | cut -f1)"
fi

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
