#!/bin/bash

# ==========================================================
# 【统一美化】WiFi 功率双模式一键切换
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

mkdir -p package/base-files/files/usr/lib/lua/luci/{controller,view}
cat > package/base-files/files/usr/lib/lua/luci/controller/wifimode.lua <<'EOF'
module("luci.controller.wifimode", package.seeall)
function index()
    entry({"admin","network","wifimode"}, template("wifimode"), _("WiFi 功率模式"), 60)
end
EOF

cat > package/base-files/files/usr/lib/lua/luci/view/wifimode.htm <<'EOF'
<%+header%>
<div class="container">
    <div class="card">
        <div class="card-header">
            <h4>📡 WiFi 功率模式</h4>
        </div>
        <div class="card-body">
            <div class="alert alert-primary">
                切换后 WiFi 自动重启，不影响已连接设备
            </div>
            <div class="mb-3">
                <button class="btn btn-primary w-100 py-2" onclick="setMode('cn')">
                    <i class="bi bi-wifi"></i> 国内标准模式 CN 20dBm
                </button>
            </div>
            <div class="mb-3">
                <button class="btn btn-success w-100 py-2" onclick="setMode('strong')">
                    <i class="bi bi-boxes"></i> 穿墙增强模式 US 28dBm
                </button>
            </div>
            <div id="msg" class="mt-3 text-center fw-bold"></div>
        </div>
    </div>
</div>

<script>
function setMode(m) {
    fetch('/cgi-bin/luci/admin/network/wifimode?op='+m)
    .then(res=>res.json())
    .then(data=>{
        const msg = document.getElementById('msg');
        msg.textContent = data.msg;
        msg.className = data.ret ? 'mt-3 text-danger fw-bold' : 'mt-3 text-success fw-bold';
    })
}
</script>
<%+footer%>
EOF

# ==========================================================
# 【统一美化】一键恢复默认
# ==========================================================
cat > package/base-files/files/usr/lib/lua/luci/controller/resetdefault.lua <<'EOF'
module("luci.controller.resetdefault", package.seeall)
function index()
    entry({"admin","system","resetdefault"}, template("resetdefault"), _("一键恢复默认"), 61)
end
EOF

cat > package/base-files/files/usr/lib/lua/luci/view/resetdefault.htm <<'EOF'
<%+header%>
<div class="container">
    <div class="card">
        <div class="card-header bg-danger text-white">
            <h4>🔄 一键恢复出厂设置</h4>
        </div>
        <div class="card-body">
            <div class="alert alert-warning">
                恢复后所有配置清空，路由器自动重启
            </div>
            <button class="btn btn-danger w-100 py-2" onclick="doReset()">
                <i class="bi bi-arrow-clockwise"></i> 确认恢复默认配置
            </button>
            <div id="info" class="mt-3 text-center fw-bold text-danger"></div>
        </div>
    </div>
</div>

<script>
function doReset() {
    if(!confirm('⚠ 确定恢复出厂并重启？')) return;
    fetch('/cgi-bin/luci/admin/system/resetdefault?do=1')
    document.getElementById('info').textContent = '正在恢复… 即将重启';
    setTimeout(()=>location.href='/',5000);
}
</script>
<%+footer%>
EOF

# ==========================================================
# 【统一美化】IPv6 一键开关
# ==========================================================
cat > package/base-files/files/usr/lib/lua/luci/controller/ipv6ctrl.lua <<'EOF'
module("luci.controller.ipv6ctrl", package.seeall)
function index()
    entry({"admin","network","ipv6ctrl"}, template("ipv6ctrl"), _("IPv6 一键控制"), 62)
end
EOF

cat > package/base-files/files/usr/lib/lua/luci/view/ipv6ctrl.htm <<'EOF'
<%+header%>
<div class="container">
    <div class="card">
        <div class="card-header">
            <h4>🌐 IPv6 一键开关</h4>
        </div>
        <div class="card-body">
            <div class="alert alert-info">
                适配国内宽带 IPv6 快速切换
            </div>
            <div class="mb-3">
                <button class="btn btn-primary w-100 py-2" onclick="setIPv6('on')">
                    <i class="bi bi-globe"></i> 启用 IPv6
                </button>
            </div>
            <div class="mb-3">
                <button class="btn btn-secondary w-100 py-2" onclick="setIPv6('off')">
                    <i class="bi bi-globe2"></i> 关闭 IPv6
                </button>
            </div>
            <div id="msg" class="mt-3 text-center fw-bold"></div>
        </div>
    </div>
</div>

<script>
function setIPv6(m) {
    fetch('/cgi-bin/luci/admin/network/ipv6ctrl?op='+m)
    .then(res=>res.json())
    .then(data=>{
        const msg = document.getElementById('msg');
        msg.textContent = data.msg;
        msg.className = data.ret ? 'mt-3 text-danger fw-bold' : 'mt-3 text-success fw-bold';
    })
}
</script>
<%+footer%>
EOF

cat > package/base-files/files/etc/ipv6ctrl.sh <<'EOF'
#!/bin/sh
mode="$1"

if [ "$mode" = "on" ]; then
    uci set network.globals.ula_prefix='auto'
    uci set network.wan6.proto='dhcpv6'
    uci set network.wan6.auto='1'
    uci set dhcp.lan.dhcpv6='server'
    uci set dhcp.lan.ra='server'
    uci commit
else
    uci set network.globals.ula_prefix=''
    uci set network.wan6.proto='none'
    uci set network.wan6.auto='0'
    uci set dhcp.lan.dhcpv6='disabled'
    uci set dhcp.lan.ra='disabled'
    uci commit
fi

/etc/init.d/network restart
/etc/init.d/odhcpd restart 2>/dev/null
EOF

chmod +x package/base-files/files/etc/ipv6ctrl.sh

# ==========================================================
# 【统一美化版】一键旁路由设置 (默认不开启)
# ==========================================================
cat > package/base-files/files/usr/lib/lua/luci/controller/gateway.lua <<'EOF'
module("luci.controller.gateway", package.seeall)
function index()
    entry({"admin","network","gateway"}, template("gateway"), _("旁路由设置"), 63)
end
EOF

cat > package/base-files/files/usr/lib/lua/luci/view/gateway.htm <<'EOF'
<%+header%>
<div class="container">
    <div class="card">
        <div class="card-header">
            <h4>🔌 旁路由一键设置</h4>
        </div>
        <div class="card-body">
            <div class="alert alert-warning">
                仅适用于旁路由模式，设置前请确保主路由 DHCP 已关闭！
            </div>
            <div class="mb-3">
                <button class="btn btn-primary w-100 py-2" onclick="setGateway()">
                    <i class="bi bi-router"></i> 设置为旁路由（静态IP）
                </button>
            </div>
            <div class="mb-3">
                <button class="btn btn-secondary w-100 py-2" onclick="resetDHCP()">
                    <i class="bi bi-arrow-repeat"></i> 恢复默认网关/DHCP
                </button>
            </div>
            <div id="msg" class="mt-3 text-center fw-bold"></div>
        </div>
    </div>
</div>

<script>
function setGateway() {
    if(!confirm('确定设置为旁路由？\nIP: 192.168.123.1\n网关: 192.168.123.1\n关闭 DHCP')) return;
    fetch('/cgi-bin/luci/admin/network/gateway?op=set')
    .then(res=>res.json())
    .then(data=>{
        const msg = document.getElementById('msg');
        msg.textContent = data.msg;
        msg.className = data.ret ? 'mt-3 text-danger fw-bold' : 'mt-3 text-success fw-bold';
    })
}

function resetDHCP() {
    fetch('/cgi-bin/luci/admin/network/gateway?op=reset')
    .then(res=>res.json())
    .then(data=>{
        const msg = document.getElementById('msg');
        msg.textContent = data.msg;
        msg.className = data.ret ? 'mt-3 text-danger fw-bold' : 'mt-3 text-success fw-bold';
    })
}
</script>
<%+footer%>
EOF

cat > package/base-files/files/etc/gateway.sh <<'EOF'
#!/bin/sh
mode="$1"

if [ "$mode" = "set" ]; then
    # 旁路由配置
    uci set network.lan.proto="static"
    uci set network.lan.ipaddr="192.168.123.1"
    uci set network.lan.netmask="255.255.255.0"
    uci set network.lan.gateway="192.168.123.1"
    uci set network.lan.dns="192.168.123.1"
    uci set dhcp.lan.ignore="1"
    uci commit
    /etc/init.d/network restart
    /etc/init.d/dnsmasq restart
elif [ "$mode" = "reset" ]; then
    # 恢复默认
    uci set network.lan.proto="static"
    uci set network.lan.ipaddr="192.168.123.1"
    uci set network.lan.netmask="255.255.255.0"
    uci set network.lan.gateway=""
    uci set network.lan.dns=""
    uci set dhcp.lan.ignore="0"
    uci commit
    /etc/init.d/network restart
    /etc/init.d/dnsmasq restart
fi
EOF

chmod +x package/base-files/files/etc/gateway.sh

# 后台接口
cat > package/base-files/files/usr/lib/lua/luci/controller/gateway_api.lua <<'EOF'
module("luci.controller.gateway_api", package.seeall)
function index()
    entry({"admin","network","gateway"}, call("gateway"))
end
function gateway()
    local op = luci.http.formvalue("op")
    if op == "set" then
        luci.sys.exec("/etc/gateway.sh set")
        luci.http.write_json({ret=0,msg="✅ 已设为旁路由，DHCP已关闭"})
    elseif op == "reset" then
        luci.sys.exec("/etc/gateway.sh reset")
        luci.http.write_json({ret=0,msg="✅ 已恢复默认网关与DHCP"})
    end
end
EOF

