#! /bin/bash -e

device=""  # monitor or keyboard
target=""  # Target device (value for the light command-line -s param)
light_opts=()

while getopts ":d:A:U:" opt; do
    case "$opt" in
    d)
        device="$OPTARG"
        case "$device" in
            "monitor")
                target="sysfs/backlight/intel_backlight"
                ;;
            "keyboard")
                target="sysfs/leds/smc::kbd_backlight"
                ;;
            *)
                echo "Invalid device: $OPTARG" >&2
                exit 1
                ;;
        esac
        light_opts+=("-s" "$target")
        ;;
    A)
        light_opts+=("-A" "$OPTARG")
        ;;
    U)
        light_opts+=("-U" "$OPTARG")
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

[[ -z "$device" ]] && echo "Option -d is required." >&2 && exit 1

sudo light "${light_opts[@]}"

notify-send \
    "${device^} brightness"\ "Set to <b>$(light -s $target)%</b>"\
    -t 1000
