ip link set wlp1s0 down
iw dev wlp1s0 set type ibss
wpa_supplicant -D nl80211,wext -i wlp1s0 -c /etc/wpa_supplicant/example.conf -B
dhcpcd wlp1s0
