#!/bin/sh

logger "friendlyelec /root/setup.sh running"

PLATFORM='sun8i|sun50i'
if ! grep -E $PLATFORM /sys/class/sunxi_info/sys_info -q; then
        logger "only support $PLATFORM. exiting..."
        exit 0
fi

board=`grep "board_name" /sys/class/sunxi_info/sys_info`
board=${board#*FriendlyElec }

logger "setup openwrt for ${board}..."
cp -r /root/board/${board}/etc/* /etc/        
uci commit             
/etc/init.d/led restart

if grep ssid /etc/config/wireless -q; then
        # setup ssid
        path=`find /sys/ -name wlan* | tail -n 1`
        wifi_mac=`cat ${path}/address`
        sed -i "s/OpenWrt/OpenWrt-${wifi_mac}/" /etc/config/wireless
fi

/etc/init.d/network restart
logger "done"