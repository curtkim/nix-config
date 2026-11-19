#!/bin/sh
# Configure an ipTIME AX3000Q running OpenWrt as a pure wireless AP for the
# homelab: three SSIDs across two VLANs, carried to the NixOS router (roter)
# over a single cable on lan1.
#
#   sanggyun5g   5GHz    -> VLAN 20 tagged -> roter enp3s0.20  10.0.20.0/24
#   sanggyun2g   2.4GHz  -> VLAN 20 tagged -> roter enp3s0.20  10.0.20.0/24
#   sanggyun2    2.4GHz  -> VLAN 30 tagged -> roter enp3s0.30  10.0.30.0/24  (IoT, no internet)
#
# Both VLANs are tagged, which is what lets this be two plain bridges over
# VLAN sub-interfaces of lan1 rather than one VLAN-filtering bridge. That
# matters: with filtering, the AP's own address lives on br-lan.20, and if
# that interface does not come up there is no way back in - which is how
# this box got bricked twice. Here the address sits directly on an ordinary
# bridge, the wireless interfaces join ordinary bridges, and nothing
# depends on bridge VLAN membership working.
#
# lan1 itself is deliberately NOT a bridge port. A port enslaved to a bridge
# swallows its own tagged frames, so lan1.20 and lan1.30 would never see
# anything. Only the two sub-interfaces are bridged.
#
# sanggyun2 is a second BSS on the 2.4GHz radio, because IoT devices are
# almost always 2.4GHz-only and that radio already carries sanggyun2g.
# (This is the thing Liminix could not express: its hostapd module takes a
# flat attrset of parameters, so it cannot emit repeated bss= sections.)
#
# Addressing, DHCP, DNS and firewalling all belong to the router. This box
# only bridges, and keeps two static addresses for management.
#
# Run it on the AP, over ssh, while it is still on its post-flash
# 192.168.1.1 and not yet plugged into the rest of the network - two DHCP
# servers on one segment is a confusing way to spend an evening.
#
# Usage: ./openwrt-init.sh <wpa-passphrase>
#
# The passphrase is an argument rather than a variable in the file so that
# this script can live in git without carrying the secret.

WPA="$1"

if [ -z "$WPA" ]; then
    echo "usage: $0 <wpa-passphrase>" >&2
    exit 1
fi
case ${#WPA} in
    [0-7]|6[4-9]|[7-9][0-9]|[0-9][0-9][0-9]*)
        echo "a WPA passphrase has to be 8 to 63 characters" >&2
        exit 1
        ;;
esac
# Not `command -v uci`: busybox builds in this corner of the world do not
# always have `command`. Reading the config proves both that uci is there
# and that it works.
if ! uci -q show wireless >/dev/null 2>&1; then
    echo "cannot read uci wireless config - is this really the OpenWrt box?" >&2
    exit 1
fi

# The radio-to-band mapping below is hardcoded, so check it rather than
# silently configuring 2.4GHz settings onto the 5GHz radio.
if [ "$(uci -q get wireless.radio0.band)" != "2g" ] ||
   [ "$(uci -q get wireless.radio1.band)" != "5g" ]; then
    echo "expected radio0=2g and radio1=5g, got:" >&2
    uci show wireless | grep '\.band=' >&2
    echo "swap radio0/radio1 below before running this" >&2
    exit 1
fi

# Refuse to run against a RAM-backed overlay. On this board the bootloader's
# recovery TFTP writes the kernel and rootfs volumes but does not create
# rootfs_data, and fstools does not create it either - it quietly falls back
# to an overlay on /tmp/root, so every uci commit survives exactly until the
# next reboot. That cost three rounds of "the config vanished again" before
# anyone looked at `mount`. Fix it with:
#
#   ubinfo -a | grep available
#   ubimkvol /dev/ubi0 -N rootfs_data -m
#   reboot
#
# (If an old `liminix` volume is still holding the free space, remove it
# first: ubirmvol /dev/ubi0 -N liminix)
if mount | grep -q "on /overlay .*tmpfs" || mount | grep -q "overlayfs:/tmp/root"; then
    echo "the overlay is in RAM, so nothing written here would survive a reboot." >&2
    echo "create the rootfs_data volume first - see the comment above this check." >&2
    mount | grep -E "overlay|ubifs" >&2
    exit 1
fi

## Network ###################################################################

# Start from nothing rather than editing around the default br-lan, which
# has lan1 as a plain member - exactly what has to not happen here.
while uci -q delete network.@device[0]; do :; done
while uci -q delete network.@bridge-vlan[0]; do :; done
uci -q delete network.wan
uci -q delete network.wan6

# VLAN 20, the main LAN. lan1.20 carries it to roter; lan2-4 are untagged
# members, which makes the AP a small switch and, more usefully, means a
# laptop plugged into any of them can always reach the AP.
uci set network.d20=device
uci set network.d20.name='br-vlan20'
uci set network.d20.type='bridge'
uci add_list network.d20.ports='lan1.20'
uci add_list network.d20.ports='lan2'
uci add_list network.d20.ports='lan3'
uci add_list network.d20.ports='lan4'

# VLAN 30, the IoT segment. Nothing but the one sub-interface: IoT clients
# reach the router and nothing else on this box.
uci set network.d30=device
uci set network.d30.name='br-vlan30'
uci set network.d30.type='bridge'
uci add_list network.d30.ports='lan1.30'

# Static, and outside the router's DHCP pool (10.0.20.100-249). Not DHCP: if
# DHCP ever breaks this is how you get back in. The gateway and resolver are
# only so that the AP itself can reach apk and NTP.
uci set network.lan=interface
uci set network.lan.device='br-vlan20'
uci set network.lan.proto='static'
uci set network.lan.ipaddr='10.0.20.2'
uci set network.lan.netmask='255.255.255.0'
uci set network.lan.gateway='10.0.20.1'
uci set network.lan.dns='10.0.20.1'

# A second address on the same bridge, kept forever as a way in that does
# not depend on the router existing or on 10.0.20.0/24 being right. Plug a
# laptop into lan2-4, give it 192.168.1.x, and the AP answers. Nothing else
# here uses 192.168.1.0/24, so it costs nothing to leave in place.
uci set network.rescue=interface
uci set network.rescue.device='br-vlan20'
uci set network.rescue.proto='static'
uci set network.rescue.ipaddr='192.168.1.1'
uci set network.rescue.netmask='255.255.255.0'

# No address: this is an L2 path for the IoT SSID and nothing else, so IoT
# clients cannot reach the AP's admin interface at all.
uci set network.iot=interface
uci set network.iot.device='br-vlan30'
uci set network.iot.proto='none'
uci set network.iot.auto='1'

## Wireless ##################################################################

while uci -q delete wireless.@wifi-iface[0]; do :; done

# HT20 rather than HE20 on 2.4GHz: this radio has to serve IoT devices, some
# of which get confused by HE beacons, and HE buys almost nothing at 2.4GHz.
uci set wireless.radio0.disabled='0'
uci set wireless.radio0.country='KR'
uci set wireless.radio0.channel='6'
uci set wireless.radio0.htmode='HT20'

uci set wireless.radio1.disabled='0'
uci set wireless.radio1.country='KR'
uci set wireless.radio1.channel='36'
uci set wireless.radio1.htmode='HE80'

# WPA2 throughout, one passphrase. WPA3/sae-mixed is left alone because the
# IoT SSID shares a passphrase with the others and IoT clients break on it.
uci set wireless.w_main=wifi-iface
uci set wireless.w_main.device='radio1'
uci set wireless.w_main.mode='ap'
uci set wireless.w_main.network='lan'
uci set wireless.w_main.ssid='sanggyun5g'
uci set wireless.w_main.encryption='psk2'
uci set wireless.w_main.key="$WPA"

uci set wireless.w_2g=wifi-iface
uci set wireless.w_2g.device='radio0'
uci set wireless.w_2g.mode='ap'
uci set wireless.w_2g.network='lan'
uci set wireless.w_2g.ssid='sanggyun2g'
uci set wireless.w_2g.encryption='psk2'
uci set wireless.w_2g.key="$WPA"

# ieee80211w=0 explicitly: protected management frames are the other thing
# that keeps IoT clients from associating.
uci set wireless.w_iot=wifi-iface
uci set wireless.w_iot.device='radio0'
uci set wireless.w_iot.mode='ap'
uci set wireless.w_iot.network='iot'
uci set wireless.w_iot.ssid='sanggyun2'
uci set wireless.w_iot.encryption='psk2'
uci set wireless.w_iot.key="$WPA"
uci set wireless.w_iot.ieee80211w='0'

uci commit network
uci commit wireless

## Things an AP should not be running #########################################

# A second DHCP server on the segment is the classic way to make this setup
# look haunted.
/etc/init.d/dnsmasq disable  ; /etc/init.d/dnsmasq stop
/etc/init.d/odhcpd disable   ; /etc/init.d/odhcpd stop
/etc/init.d/firewall disable ; /etc/init.d/firewall stop

sync

cat <<'MSG'

Written and synced. Check it before rebooting:

  uci show network | grep -E "d20|d30|\.lan\.|\.rescue\.|\.iot\."
  uci show wireless | grep -E "ssid|network|device=|htmode"

Then `reboot` - never pull the power, the overlay loses recent writes and
you come back to factory defaults.

After the reboot this box answers on BOTH 10.0.20.2 and 192.168.1.1, on
lan1 (tagged, via roter) and on lan2-4 (untagged, straight to a laptop).
So there is no sequencing to get right and no way to lock yourself out.

Verification needs no extra packages - these read sysfs:

  ip addr show br-vlan20 | grep inet        # 10.0.20.2 and 192.168.1.1
  ls /sys/class/net/br-vlan20/brif/         # lan1.20 lan2 lan3 lan4 + 2 wlans
  ls /sys/class/net/br-vlan30/brif/         # lan1.30 + 1 wlan
  iw dev | grep -E "Interface|ssid"         # three interfaces

The IoT wlan has to be in br-vlan30 and nowhere else. If it shows up in
br-vlan20 instead, the segments are not actually separated.
MSG
