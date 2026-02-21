#!/bin/bash

# ====================== 基础信息 ======================
sed -i 's/192.168.1.1/192.168.123.1/g' package/base-files/files/etc/config/network
sed -i 's/OpenWrt/CMCC-A10/g' package/base-files/files/etc/config/system

# ====================== CMCC A10 专属 · 深度美化 Argon 主题 ======================
cat > package/base-files/files/etc/config/argon <<EOF
config argon config
    option blur "2"
    option brightness "70"
    option darkmode "2"
    option fontsize "14"
    option header "CMCC A10 WiFi6"
    option navbarfixed "1"
    option opacity "0.8"
    option position "center"
    option primary "#38BDF8"
    option radius "10"
    option size "cover"
    option theme "auto"
    option title "CMCC A10 · 智能路由固件"
EOF

# 强制默认主题为 Argon
mkdir -p package/base-files/files/etc/uci-defaults/
cat > package/base-files/files/etc/uci-defaults/99-theme <<'EOF'
#!/bin/sh
uci set luci.main.mediaurlbase='/luci-static/argon'
uci set luci.main.polltime='5'
uci commit luci
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-theme

# ====================== 默认 WiFi ======================
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
    option disabled '0'

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
    option disabled '0'
EOF

# ====================== 顶部标题统一 ======================
mkdir -p package/base-files/files/usr/lib/lua/luci/view
cat > package/base-files/files/usr/lib/lua/luci/view/header.htm <<'EOF'
<% local ver = require "luci.version" %>
<!DOCTYPE html>
<html lang="<%=luci.i18n.language%>">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, maximum-scale=1.0">
    <title><%=striptags(luci.config.main.mainpage_title or "CMCC A10 WiFi6 路由")%></title>
    <link rel="shortcut icon" href="/luci-static/argon/favicon.png" type="image/x-icon">
    <%+cbi/css %>
</head>
<body class="<%=luci.dispatcher.context.pcstate%>">
    <div class="main">
        <header class="header">
            <div class="logo">
                <span class="logo-text">CMCC A10</span>
            </div>
        </header>
        <div class="container body">
<%+cbi/menu%>
<div class="content">
EOF

# ====================== 底部统一 ======================
cat > package/base-files/files/usr/lib/lua/luci/view/footer.htm <<'EOF'
</div></div></div>
<footer class="footer">
    <div class="container">
        <div class="text-center">
            <strong>CMCC A10 WiFi6 定制固件</strong> &copy; 2026
        </div>
    </div>
</footer>
</body>
</html>
EOF
