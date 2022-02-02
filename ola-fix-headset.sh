#!/usr/bin/env bash

set -e

echo "Restarting bluetooth driver 🧢"
systemctl restart bluetooth

sleep 2

# Replace with desired mac adress
mac_adress=30:50:75:48:76:CC

#Connect to headset
echo "connect ${mac_adress}" | bluetoothctl > /dev/null

## Check if headset is in list of connected bluetooth devices
# pactl uses underscore instead of colon in mac adress
regex="([0-9]+)\s[a-z_]+.${mac_adress//:/_}"
while [[ ! $(pactl list cards short) =~ $regex ]]; do
    echo "Waiting for headset to reconnect... 🔌"
    sleep 5
done

sleep 3

## Set nice high-fidelity audio profile
pactl_index=${BASH_REMATCH[1]}
pacmd set-card-profile "$pactl_index" "a2dp_sink"

echo "Success 🎧🎧"
