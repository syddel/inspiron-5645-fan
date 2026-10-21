#!/usr/bin/env bash

PWM="/sys/class/hwmon/hwmon6/pwm1"
ENABLE="/sys/class/hwmon/hwmon6/pwm1_enable"
RPM="/sys/class/hwmon/hwmon6/fan1_input"
CPU_TEMP="/sys/class/hwmon/hwmon6/temp1_input"

case "$1" in
    auto)
        echo 2 | sudo tee "$ENABLE" >/dev/null
        echo "Fan control: automatic"
        ;;

    status)
        ENABLE_STATE=$(cat "$ENABLE")

        if [[ "$ENABLE_STATE" == "1" ]]; then
            STATUS="manual"
            CURRENT_PWM=$(cat "$PWM")
        else
            STATUS="automatic"
            CURRENT_PWM="N/A"
        fi

        CURRENT_RPM=$(cat "$RPM")
        CPU_TEMP_VALUE=$(cat "$CPU_TEMP")
        CPU_TEMP_C=$((CPU_TEMP_VALUE / 1000))

        echo "Status: $STATUS"
        echo "PWM: $CURRENT_PWM"
        echo "Current RPM: $CURRENT_RPM"
        echo "CPU Temperature: ${CPU_TEMP_C}°C"
        ;;

    ''|*[!0-9]*)
        echo "Usage: fan {0-255|auto|status}"
        exit 1
        ;;

    *)
        if (( "$1" > 255 )); then
            echo "PWM must be between 0 and 255"
            exit 1
        fi

        echo 1 | sudo tee "$ENABLE" >/dev/null
        echo "$1" | sudo tee "$PWM" >/dev/null
        echo "Fan PWM: $1"
        ;;
esac
