#!/usr/bin/env bash
#
# fan-watch
#
# Continuously print pwm1_enable / pwm1 / fan1_input for the Dell SMM
# hwmon device, once per second, until interrupted with Ctrl-C.
#
# Useful for diagnosing whether the BIOS is reclaiming fan control.
#

set -u

HWMON_NAME="dell_smm"
INTERVAL=1

# ---------------------------------------------------------------------------
# Locate the hwmon directory by device name (hwmonN index is not stable).
# ---------------------------------------------------------------------------
find_hwmon() {
    local d
    for d in /sys/class/hwmon/hwmon*; do
        [[ -d "$d" ]] || continue
        if [[ "$(cat "$d/name" 2>/dev/null)" == "$HWMON_NAME" ]]; then
            echo "$d"
            return 0
        fi
    done
    return 1
}

HWMON_DIR=$(find_hwmon) || {
    echo "ERROR: hwmon device '$HWMON_NAME' not found." >&2
    echo "Available hwmon devices:" >&2
    for d in /sys/class/hwmon/hwmon*; do
        [[ -d "$d" ]] || continue
        printf '  %s -> %s\n' "$d" "$(cat "$d/name" 2>/dev/null)" >&2
    done
    exit 1
}

PWM="$HWMON_DIR/pwm1"
ENABLE="$HWMON_DIR/pwm1_enable"
RPM="$HWMON_DIR/fan1_input"

printf 'Watching %s (%s), interval %ss. Press Ctrl-C to stop.\n\n' \
    "$HWMON_DIR" "$HWMON_NAME" "$INTERVAL"

# Clean newline on exit so the shell prompt doesn't get glued to our output.
trap 'echo; exit 0' INT TERM

while true; do
    enable=$(cat "$ENABLE" 2>/dev/null || echo "?")
    pwm=$(cat "$PWM" 2>/dev/null || echo "?")
    rpm=$(cat "$RPM" 2>/dev/null || echo "?")
    printf '%s enable=%s pwm=%s rpm=%s\n' "$(date +%T)" "$enable" "$pwm" "$rpm"
    sleep "$INTERVAL"
done
