#!/bin/bash

set -e

DEV=/dev/input/by-path/platform-gpio_keys-event

# Returns true (0) if power switch is at ON position, otherwise flase (non-0)
test_sw_on() {
    ! evtest --query "$DEV" EV_SW SW_LID
}

# Returns true (0) if power switch is at AUTO  position, otherwise flase (non-0)
test_sw_auto() {
    ! evtest --query "$DEV" EV_SW SW_TABLET_MODE
}

echo --- Power Switch Watcher for the Buffalo LinkStation ---

# Sanity checks:
if  [[ $EUID > 0 ]]; then
    >&2 echo Error: This script can only be run as root.
    exit 1
fi
if ! command -v evtest > /dev/null 2>&1; then
    >&2 echo Error: \`evtest\ is not available!
    exit 1
fi
if [ ! -e "$DEV" ]; then
    >&2 echo Error: Device "$DEV" does not exist!
    exit 1
fi

PATTERN_SW_ON_0="*type 5 (EV_SW), code 0 (SW_LID), value 0"
PATTERN_SW_ON_1="*type 5 (EV_SW), code 0 (SW_LID), value 1"
PATTERN_SW_AUTO_0="*type 5 (EV_SW), code 1 (SW_TABLET_MODE), value 0"
PATTERN_SW_AUTO_1="*type 5 (EV_SW), code 1 (SW_TABLET_MODE), value 1"

test_sw_on && state_on=1 || state_on=0
test_sw_auto && state_auto=1 || state_auto=0
echo Initial state of switch: ON=$state_on AUTO=$state_auto

unset delay_shutdown_pid

evtest "$DEV" | while read -r line; do
    case $line in
        $PATTERN_SW_ON_0)
            echo Power switch moved away from ON
            state_on=0
            ;;
        $PATTERN_SW_ON_1)
            echo Power switch moved to ON
            state_on=1
            ;;
        $PATTERN_SW_AUTO_0)
            echo Power switch moved away from AUTO
            state_auto=0
            ;;
        $PATTERN_SW_AUTO_1)
            echo Power switch moved to AUTO
            state_auto=1
            ;;
    esac
    if [[ $state_on == 0 && $state_auto == 0 ]]; then
        if [ ! -v delay_shutdown_pid ]; then
            (
                echo Pending shutdown in 2 seconds...
                sleep 2
                echo Shutting down now!
                poweroff
            ) &
            delay_shutdown_pid=$!
        fi
    else
        if [ -v delay_shutdown_pid ]; then
            kill $delay_shutdown_pid
            unset delay_shutdown_pid
            echo Aborted pending shutdown.
        fi
    fi
done
