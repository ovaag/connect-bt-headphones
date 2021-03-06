#!/usr/bin/env bash

set -e


# Install dependencies or do nothing if already installed
#
# Useful to quickly continue without sudo password prompt when
# nothing needs to be installed.
apt_install() {
    for package in "$@"
    do
        # https://askubuntu.com/a/423555/313644
        if ! dpkg -s "$package" &> /dev/null
        then
            sudo apt-get install -qq "$package"
        fi
    done
}

apt_install pulseaudio-utils bluez

echo "Restarting bluetooth driver ๐งข"
systemctl restart bluetooth

sleep 3

# Replace with desired mac adress
mac_adress=30:50:75:48:76:CC

#Connect to headset
echo "connect ${mac_adress}" | bluetoothctl > /dev/null

## Check if headset is in list of connected bluetooth devices
# pactl uses underscore instead of colon in mac adress
regex="([0-9]+)\s[a-z_]+.${mac_adress//:/_}"
echo "Waiting for headset to reconnect... ๐"
while [[ ! $(pactl list cards short) =~ $regex ]]; do
	sleep 1
done

sleep 3

## Set nice high-fidelity audio profile
pactl_index=${BASH_REMATCH[1]}
pacmd set-card-profile "$pactl_index" "a2dp_sink"

echo "Success ๐ง๐ง"
