#!/usr/bin/env bash

set -e

echo "Restarting bluetooth driver 🧢"
systemctl restart bluetooth

sleep 5

echo "connect 30:50:75:48:76:CC" | bluetoothctl > /dev/null

regex="([0-9]+)\sbluez"

while [[ ! $(pactl list cards short) =~ $regex ]]
do
    echo "Waiting for headset to reconnect... 🔌"
    sleep 2
done

sleep 2

pactl_index=${BASH_REMATCH[1]}
pacmd set-card-profile $pactl_index "a2dp_sink"

echo "Success 🎧🎧"
