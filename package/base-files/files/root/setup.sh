#!/bin/ash

board=`grep "board_name" /sys/class/sunxi_info/sys_info`
board=${board#*FriendlyElec }
echo board=${board}

#if [ "x${board}" = "xNanoPi-R1" ]; then
echo "setup openwrt for ${board}..."
cp -r /root/board/${board}/etc/* /etc/        
uci commit             
/etc/init.d/led restart
/etc/init.d/network restart
echo "done"
#fi

# setup ssid
wifi_mac=`cat /sys/devices/platform/soc/1c10000.mmc/mmc_host/mmc2/mmc2:0001/mmc2:0001:1/ieee80211/phy0/macaddress`
sed -i "s/OpenWrt/OpenWrt-${wifi_mac}/" /etc/config/wireless
