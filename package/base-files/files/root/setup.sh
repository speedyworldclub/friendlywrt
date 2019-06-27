#!/bin/sh

setup_ssid()
{
    local r=$1

    if ! uci show wireless.${r} >/dev/null; then
        return
    fi

    logger "setup $1's ssid"
    WLAN_PATH=/sys/devices/`uci get wireless.${r}.path`
    WLAN_PATH=`find ${WLAN_PATH} -name wlan* | tail -n 1`
    MAC=`cat ${WLAN_PATH}/address`
    uci set wireless.default_${r}.ssid="OpenWrt-${MAC}"
    uci commit
}

logger "friendlyelec /root/setup.sh running"

PLATFORM='sun8i|sun50i'
if ! grep -E $PLATFORM /sys/class/sunxi_info/sys_info -q; then
        logger "only support $PLATFORM. exiting..."
        exit 0
fi

BOARD=`grep "board_name" /sys/class/sunxi_info/sys_info`
BOARD=${BOARD#*FriendlyElec }

logger "setup openwrt for ${BOARD}..."
cp -r /root/board/${BOARD}/etc/* /etc/
/etc/init.d/led restart

RADIO=radio0
SSID=`uci get wireless.default_${RADIO}.ssid`
if [ -n "${SSID}" ]; then
    setup_ssid radio0
fi

/etc/init.d/network restart
logger "done"