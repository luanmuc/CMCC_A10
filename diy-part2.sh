#!/bin/bash

#=============================
# 基础信息
#=============================
sed -i 's/192.168.1.1/192.168.123.1/g' package/base-files/files/etc/config/network
sed -i 's/OpenWrt/CMCC-A10/g' package/base-files/files/etc/config/system

#=============================
# 内存&网络优化
#=============================
mkdir -p package/base-files/files/etc/sysctl.d
cat > package/base-files/files/etc/sysctl.d/99-a10.conf <<EOF
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=10
vm.dirty_background_ratio=5
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=30
EOF

#=============================
# CPU 性能模式
#=============================
cat > package/base-files/files/etc/rc.local <<'EOF'
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo 1 > /proc/sys/net/netfilter/nf_conntrack_tcp_be_liberal
exit 0
EOF
chmod +x package/base-files/files/etc/rc.local

#=============================
# CMCC A10 正确双频 WiFi（237源码专用）
#=============================
cat > package/base-files/files/etc/config/wireless <<EOF
config wifi-device 'radio0'
    option type 'mac80211'
    option channel '157'
    option hwmode '11a'
    option path 'platform/soc/1a143000.wmac'
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
    option path 'platform/soc/18000000.wmac'
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

#=============================
# Argon 配置
#=============================
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

#=============================
# 默认主题
#=============================
mkdir -p package/base-files/files/etc/uci-defaults
cat > package/base-files/files/etc/uci-defaults/99-theme <<'EOF'
#!/bin/sh
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-theme

#=============================
# 全局美化 CSS（最终高级版）
#=============================
WWW_CSS_DIR="package/base-files/files/www/luci-static/argon/css"
mkdir -p $WWW_CSS_DIR
cat > $WWW_CSS_DIR/cust-style.css <<EOF
/* 全局卡片：柔和、高级、无边框 */
.card,
.main-card,
.td-card,
.panel,
.table,
.table-responsive {
    border-radius: 18px !important;
    box-shadow: 0 6px 22px rgba(0,0,0,0.06) !important;
    border: none !important;
    overflow: hidden !important;
    background: #fff !important;
    margin-bottom: 16px !important;
}
.darkmode .card,
.darkmode .panel {
    background: #1e1e1e !important;
    box-shadow: 0 6px 22px rgba(0,0,0,0.2) !important;
}

/* 标题更精致、不突兀 */
.page-title,
h1, h2, h3, h4, .card-title {
    font-weight: 600 !important;
    letter-spacing: 0.2px !important;
    color: #222 !important;
    margin-bottom: 12px !important;
}
.darkmode .page-title,
.darkmode h1, .darkmode h2, .darkmode h3 {
    color: #eee !important;
}

/* 按钮：渐变+圆角+微动效 */
.btn {
    border-radius: 12px !important;
    font-weight: 500 !important;
    padding: 8px 16px !important;
    border: none !important;
    transition: all 0.25s ease !important;
}
.btn-primary {
    background: linear-gradient(135deg, #3B82F6, #60A5FA) !important;
}
.btn-success {
    background: linear-gradient(135deg, #10B981, #34D399) !important;
}
.btn-danger {
    background: linear-gradient(135deg, #EF4444, #F87171) !important;
}
.btn-warning {
    background: linear-gradient(135deg, #F59E0B, #FBBF24) !important;
}
.btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.12);
}

/* 输入框、下拉框更圆润 */
.form-control,
.form-select {
    border-radius: 12px !important;
    border: 1px solid #e2e8f0 !important;
    padding: 8px 12px !important;
    transition: all 0.2s !important;
}
.form-control:focus,
.form-select:focus {
    border-color: #3B82F6 !important;
    box-shadow: 0 0 0 3px rgba(59,130,246,0.2) !important;
}

/* 提示框更柔和 */
.alert {
    border-radius: 14px !important;
    border: none !important;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

/* 左侧菜单：间距更舒服 */
.main-left .nav-item {
    margin-bottom: 4px !important;
}
.main-left .nav-link {
    border-radius: 10px !important;
    padding: 10px 14px !important;
}
.main-left .nav-item i {
    margin-right: 8px !important;
    width: 16px !important;
    text-align: center !important;
    font-size: 15px !important;
}

/* 表格清爽不拥挤 */
.table th,
.table td {
    padding: 12px 14px !important;
    vertical-align: middle !important;
}

/* 开关更精致 */
.form-switch .form-check-input {
    border-radius: 20px !important;
    height: 22px !important;
    width: 40px !important;
}
EOF

#=============================
# 注入 CSS
#=============================
HEADER_FILE="package/base-files/files/usr/lib/lua/luci/view/header.htm"
mkdir -p $(dirname $HEADER_FILE)
cat > $HEADER_FILE <<'EOF'
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><%= stitle %>-<%= hostname %></title>
<link rel="stylesheet" href="/luci-static/argon/css/cust-style.css">
<%+cbi/head%>
</head>
<body class="<%= node.family %>">
<% if (dsp && widget) { %>
<%+cbi/menu%>
<% } %>
<div id="maincontent">
<div class="container">
EOF

#=============================
# 首页美化
#=============================
VIEW_DIR="package/base-files/files/usr/lib/lua/luci/view"
mkdir -p $VIEW_DIR/admin_status
cat > $VIEW_DIR/admin_status/index.htm <<EOF
<%+header%>
<div class="container">
    <div class="card p-4 text-center mb-4">
        <h2 class="page-title">🎯 CMCC A10 游戏加速固件 2.0</h2>
        <p class="text-muted mb-0">237大佬源码 | TurboACC | BBR | 全锥NAT | 低延迟专用</p>
    </div>
    <div class="card p-4">
        <h3>📊 系统状态</h3>
        <%+admin_status/sysinfo%>
        <%+admin_status/conn%>
        <%+admin_status/load%>
        <%+admin_status/memory%>
        <%+admin_status/network%>
        <%+admin_status/wireless%>
    </div>
</div>
<%+footer%>
EOF

#=============================
# 功能页面
#=============================
cat > $VIEW_DIR/gamelowlat.htm <<EOF
<%+header%>
<div class="container">
    <div class="card p-4">
        <h3 class="page-title">🎮 游戏极致低延迟模式</h3>
        <p class="text-muted mb-4">专为手游/端游优化，降低延迟，提高稳定性</p>
        <div class="mb-3">
            <label class="form-label">模式开关</label>
            <select class="form-select" name="lowlat">
                <option value="0">关闭（默认·日常稳定）</option>
                <option value="1">开启（游戏·超低延迟）</option>
            </select>
        </div>
        <div class="alert alert-info mt-3">
            ✅ <strong>优点</strong>：延迟更低，游戏更跟手<br>
            ❌ <strong>缺点</strong>：轻微增加CPU占用
        </div>
        <button class="btn btn-primary w-100 mt-3">保存并应用</button>
    </div>
</div>
<%+footer%>
EOF

cat > $VIEW_DIR/repairnet.htm <<EOF
<%+header%>
<div class="container">
    <div class="card p-4">
        <h3 class="page-title">🔧 一键恢复上网</h3>
        <p class="text-muted mb-4">不删WiFi、不恢复出厂，快速修复断网</p>
        <button class="btn btn-success w-100 py-3 mb-3">立即执行一键修复</button>
        <div class="alert alert-warning">
            💡 仅重置网络配置，不清除WiFi密码
        </div>
    </div>
</div>
<%+footer%>
EOF

cat > $VIEW_DIR/wifipower.htm <<EOF
<%+header%>
<div class="container">
    <div class="card p-4">
        <h3 class="page-title">📡 WiFi功率调节</h3>
        <p class="text-muted mb-4">根据环境选择信号强度</p>
        <div class="mb-3">
            <label class="form-label">发射功率</label>
            <select class="form-select">
                <option>低（省电·近距离）</option>
                <option selected>中（均衡·推荐）</option>
                <option>高（穿墙·远距离）</option>
            </select>
        </div>
        <button class="btn btn-primary w-100 mt-3">保存功率设置</button>
    </div>
</div>
<%+footer%>
EOF

cat > $VIEW_DIR/ipv6tool.htm <<EOF
<%+header%>
<div class="container">
    <div class="card p-4">
        <h3 class="page-title">🌐 IPv6 快速开关</h3>
        <p class="text-muted mb-4">一键切换IPv6，适配不同环境</p>
        <div class="mb-3">
            <label class="form-label">IPv6 状态</label>
            <select class="form-select">
                <option>开启</option>
                <option selected>关闭</option>
            </select>
        </div>
        <button class="btn btn-primary w-100 mt-3">应用IPv6设置</button>
    </div>
</div>
<%+footer%>
EOF

cat > $VIEW_DIR/gatewaymode.htm <<EOF
<%+header%>
<div class="container">
    <div class="card p-4">
        <h3 class="page-title">🔗 主路由 / 旁路由 切换</h3>
        <p class="text-muted mb-4">新手零难度一键切换</p>
        <div class="mb-3">
            <label class="form-label">运行模式</label>
            <select class="form-select">
                <option selected>主路由（拨号上网）</option>
                <option>旁路由（网关模式）</option>
            </select>
        </div>
        <button class="btn btn-primary w-100 mt-3">确认切换模式</button>
    </div>
</div>
<%+footer%>
EOF

#=============================
# 菜单图标
#=============================
cat > package/base-files/files/etc/uci-defaults/99-menu-icons <<'EOF'
#!/bin/sh
uci batch <<EOF
set luci.menu.game.icon='icon-gamepad'
set luci.menu.repairnet.icon='icon-wrench'
set luci.menu.wifi.icon='icon-wifi'
set luci.menu.ipv6.icon='icon-globe'
set luci.menu.gateway.icon='icon-settings'
commit luci
EOF
exit 0
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-menu-icons
