#!/bin/bash

# IP
sed -i 's/192.168.1.1/192.168.123.1/g' package/base-files/files/etc/config/network
sed -i 's/OpenWrt/CMCC-A10/g' package/base-files/files/etc/config/system

# 内存优化
cat > package/base-files/files/etc/sysctl.d/99-a10.conf <<EOF
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=10
vm.dirty_background_ratio=5
net.core.rmem_max=16777216
net.core.wmem_max=16777216
EOF

# CPU performance
cat > package/base-files/files/etc/rc.local <<'EOF'
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo 1 > /proc/sys/net/netfilter/nf_conntrack_tcp_be_liberal
exit 0
EOF

# WiFi
cat > package/base-files/files/etc/config/wireless <<EOF
config wifi-device 'radio0'
    option type 'mac80211'
    option channel '157'
    option hwmode '11a'
    option path 'platform/soc/a000000.wifi'
    option htmode 'HE80'
    option disabled '0'
    option country 'CN'
    option txpower '20'

config wifi-iface 'default_radio0'
    option device 'radio0'
    option network 'lan'
    option mode 'ap'
    option ssid 'CMCC-A10-5G'
    option encryption 'psk2+ccmp'
    option key 'lplqq123456'

config wifi-device 'radio1'
    option type 'mac80211'
    option channel '6'
    option hwmode '11g'
    option path 'platform/soc/a000000.wifi'
    option htmode 'HE40'
    option disabled '0'
    option country 'CN'
    option txpower '20'

config wifi-iface 'default_radio1'
    option device 'radio1'
    option network 'lan'
    option mode 'ap'
    option ssid 'CMCC-A10'
    option encryption 'psk2+ccmp'
    option key 'lplqq123456'
EOF

# Argon
cat > package/base-files/files/etc/config/argon <<EOF
config argon config
    option blur "2"
    option brightness "70"
    option darkmode "2"
    option fontsize "14"
    option header "CMCC A10 WiFi6"
    option navbarfixed "1"
    option opacity "0.8"
    option primary "#38BDF8"
    option radius "10"
    option theme "auto"
EOF

mkdir -p package/base-files/files/etc/uci-defaults
cat > package/base-files/files/etc/uci-defaults/99-theme <<'EOF'
#!/bin/sh
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci
EOF
chmod +x $_
