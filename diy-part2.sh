#!/bin/bash

# 基本信息
sed -i 's/192.168.1.1/192.168.123.1/g' package/base-files/files/etc/config/network
sed -i 's/OpenWrt/CMCC-A10/g' package/base-files/files/etc/config/system

# Argon 主题优化
cat > package/base-files/files/etc/config/argon <<EOF
config argon config
    option blur "3"
    option brightness "75"
    option darkmode "2"
    option fontsize "14"
    option header "CMCC A10"
    option navbarfixed "1"
    option opacity "0.8"
    option position "center"
    option primary "#38BDF8"
    option radius "8"
    option size "cover"
    option theme "auto"
    option title "CMCC A10 WiFi6 路由"
EOF

# 默认 WiFi：国内标准模式 CN 20dBm
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

# ==========================================================
# WiFi 功率双模式一键切换插件
# ==========================================================
mkdir -p package/base-files/files/etc
cat > package/base-files/files/etc/wifi-mode.sh <<'EOF'
#!/bin/sh
mode="$1"

if [ "$mode" = "cn" ]; then
cat > /etc/config/wireless <<WIFI
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
WIFI
elif [ "$mode" = "strong" ]; then
cat > /etc/config/wireless <<WIFI
config wifi-device 'radio0'
    option type 'mac80211'
    option channel '157'
    option hwmode '11a'
    option path 'platform/soc/a000000.wifi'
    option htmode 'HE80'
    option disabled '0'
    option country 'US'
    option txpower '28'

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
    option country 'US'
    option txpower '28'

config wifi-iface 'default_radio1'
    option device 'radio1'
    option network 'lan'
    option mode 'ap'
    option ssid 'CMCC-A10'
    option encryption 'psk2+ccmp'
    option key 'lplqq123456'
    option disabled '0'
WIFI
fi

wifi reload
EOF

chmod +x package/base-files/files/etc/wifi-mode.sh

mkdir -p package/base-files/files/usr/lib/lua/luci/controller
cat > package/base-files/files/usr/lib/lua/luci/controller/wifimode.lua <<'EOF'
module("luci.controller.wifimode", package.seeall)
function index()
    entry({"admin","network","wifimode"}, call("wifimode"), _("WiFi 功率模式"), 60)
end
function wifimode()
    local op = luci.http.formvalue("op")
    if op == "cn" then
        luci.sys.call("/etc/wifi-mode.sh cn")
        luci.http.write_json({ret=0,msg="✅ 已切换：国内标准模式（CN 20dBm）"})
    elseif op == "strong" then
        luci.sys.call("/etc/wifi-mode.sh strong")
        luci.http.write_json({ret=0,msg="✅ 已切换：穿墙增强模式（US 28dBm）"})
    else
        luci.template.render("wifimode")
    end
end
EOF

mkdir -p package/base-files/files/usr/lib/lua/luci/view
cat > package/base-files/files/usr/lib/lua/luci/view/wifimode.htm <<'EOF'
<%+header%>
<div class="cbi-map">
<h2>WiFi 功率模式切换</h2>
<fieldset class="cbi-section">
    <div class="cbi-section-descr">一键在国内标准和穿墙增强之间切换</div>
    <br>
    <button class="cbi-button cbi-button-apply" onclick="set('cn')">国内标准模式（CN 20dBm）</button>
    <br><br>
    <button class="cbi-button cbi-button-apply" onclick="set('strong')">穿墙增强模式（US 28dBm）</button>
    <br><br>
    <div id="msg" style="color:green;font-weight:bold"></div>
</fieldset>
</div>
<script>
function set(m){
    fetch('/cgi-bin/luci/admin/network/wifimode?op='+m)
    .then(r=>r.json()).then(d=>{ document.getElementById('msg').innerText = d.msg })
}
</script>
<%+footer%>
EOF

# ==========================================================
# 一键恢复默认配置插件
# ==========================================================
cat > package/base-files/files/usr/lib/lua/luci/controller/resetdefault.lua <<'EOF'
module("luci.controller.resetdefault", package.seeall)
function index()
    entry({"admin","system","resetdefault"}, call("resetdefault"), _("一键恢复默认配置"), 61)
end
function resetdefault()
    if luci.http.formvalue("do") == "1" then
        luci.sys.call("/sbin/firstboot -y && /sbin/reboot")
    end
    luci.template.render("resetdefault")
end
EOF

cat > package/base-files/files/usr/lib/lua/luci/view/resetdefault.htm <<'EOF'
<%+header%>
<div class="cbi-map">
<h2>一键恢复默认配置</h2>
<fieldset class="cbi-section">
    <div class="cbi-section-descr">恢复到固件出厂默认设置（WiFi、密码、主题全部还原）</div>
    <br>
    <button class="cbi-button cbi-button-reset" onclick="doReset()">点击恢复默认配置</button>
    <br><br>
    <div id="info" style="color:red"></div>
</fieldset>
</div>
<script>
function doReset(){
    if(!confirm('确定恢复默认并重启？')) return;
    fetch('/cgi-bin/luci/admin/system/resetdefault?do=1')
    document.getElementById('info').innerText = '正在恢复默认配置，路由器将重启…';
    setTimeout(()=>location.href='/',5000);
}
</script>
<%+footer%>
EOF
