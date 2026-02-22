#!/bin/sh
# ==============================================================
# CMCC A10 游戏加速固件 2.0 - 全套统一美化最终版
# 卡片式 | 渐变色 | 高颜值 | 全页面统一 | Argon 完美适配
# 菜单/标题/版本号/按钮/页面全部美化完成
# ==============================================================

# --------------------------
# 全局美化样式（全站生效）
# --------------------------
cat > /www/luci-static/argon/css/cust-style.css <<EOF
/* 全局卡片统一 */
.card, .main-card, .td-card, .panel {
    border-radius: 16px !important;
    box-shadow: 0 8px 20px rgba(0,0,0,0.08) !important;
    border: none !important;
    overflow: hidden !important;
    margin-bottom: 20px !important;
}
/* 标题美化 */
.page-title {
    font-size: 22px !important;
    font-weight: 700 !important;
    color: #222 !important;
    margin-bottom: 15px !important;
}
/* 按钮渐变 */
.btn, .btn-primary, .btn-success, .btn-danger {
    border-radius: 12px !important;
    border: 0 !important;
    font-weight: 600 !important;
    padding: 7px 18px !important;
    transition: 0.2s !important;
}
.btn-primary {
    background: linear-gradient(135deg, #3B82F6 0%, #60A5FA 100%) !important;
}
.btn-success {
    background: linear-gradient(135deg, #10B981 0%, #34D399 100%) !important;
}
.btn-danger {
    background: linear-gradient(135deg, #EF4444 0%, #F87171 100%) !important;
}
/* 输入框/选择框 */
.form-control, .form-select {
    border-radius: 12px !important;
    border: 1px solid #E5E7EB !important;
    padding: 8px 12px !important;
}
/* 开关样式 */
.form-switch .form-check-input {
    border-radius: 20px !important;
    height: 22px !important;
    width: 40px !important;
}
/* 提示框 */
.alert {
    border-radius: 14px !important;
    border: none !important;
}
/* 左侧菜单图标间距 */
.main-left .nav-item i {
    margin-right: 8px !important;
    width: 16px !important;
    text-align: center !important;
}
EOF

# 加载全局样式
sed -i '/<\/head>/i <link rel="stylesheet" href="/luci-static/argon/css/cust-style.css">' /usr/lib/lua/luci/view/header.htm

# --------------------------
# 后台顶部标题 + 版本号美化
# --------------------------
cat > /usr/lib/lua/luci/view/admin_status/index.htm <<EOF
<%+header%>
<div class="container">
    <div class="card p-4 text-center mb-4">
        <h2 class="page-title">🎯 CMCC A10 游戏加速固件 2.0</h2>
        <p class="text-muted mb-0">TurboACC | BBR | SFE | FullCone | 低延迟游戏专用</p>
    </div>
    <div class="card p-4">
        <h3>📊 系统状态</h3>
        <%+admin_status/index%>
    </div>
</div>
<%+footer%>
EOF

# --------------------------
# 1. 游戏低延迟模式 - 美化页面
# --------------------------
cat > /usr/lib/lua/luci/view/gamelowlat.htm <<EOF
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
        <button class="btn-primary w-100 mt-3">保存并应用</button>
    </div>
</div>
<%+footer%>
EOF

# --------------------------
# 2. 一键恢复上网 - 美化页面
# --------------------------
cat > /usr/lib/lua/luci/view/repairnet.htm <<EOF
<%+header%>
<div class="container">
    <div class="card p-4">
        <h3 class="page-title">🔧 一键恢复上网</h3>
        <p class="text-muted mb-4">不删WiFi、不恢复出厂，快速修复断网问题</p>
        <button class="btn-success w-100 py-3 mb-3">立即执行一键修复</button>
        <div class="alert alert-warning">
            💡 仅重置网络配置，不会清除您的WiFi名称与密码
        </div>
    </div>
</div>
<%+footer%>
EOF

# --------------------------
# 3. WiFi功率调节 - 美化页面
# --------------------------
cat > /usr/lib/lua/luci/view/wifipower.htm <<EOF
<%+header%>
<div class="container">
    <div class="card p-4">
        <h3 class="page-title">📡 WiFi功率调节</h3>
        <p class="text-muted mb-4">根据使用环境选择信号强度</p>
        <div class="mb-3">
            <label class="form-label">发射功率</label>
            <select class="form-select">
                <option>低（省电·近距离）</option>
                <option selected>中（均衡·推荐）</option>
                <option>高（穿墙·远距离）</option>
            </select>
        </div>
        <button class="btn-primary w-100 mt-3">保存功率设置</button>
    </div>
</div>
<%+footer%>
EOF

# --------------------------
# 4. IPv6快速开关 - 美化页面
# --------------------------
cat > /usr/lib/lua/luci/view/ipv6tool.htm <<EOF
<%+header%>
<div class="container">
    <div class="card p-4">
        <h3 class="page-title">🌐 IPv6 快速开关</h3>
        <p class="text-muted mb-4">一键切换IPv6网络，适配不同上网环境</p>
        <div class="mb-3">
            <label class="form-label">IPv6 运行状态</label>
            <select class="form-select">
                <option>开启</option>
                <option selected>关闭</option>
            </select>
        </div>
        <button class="btn-primary w-100 mt-3">应用IPv6设置</button>
    </div>
</div>
<%+footer%>
EOF

# --------------------------
# 5. 旁路由模式切换 - 美化页面
# --------------------------
cat > /usr/lib/lua/luci/view/gatewaymode.htm <<EOF
<%+header%>
<div class="container">
    <div class="card p-4">
        <h3 class="page-title">🔗 旁路由 / 主路由 切换</h3>
        <p class="text-muted mb-4">一键切换工作模式，新手零难度</p>
        <div class="mb-3">
            <label class="form-label">运行模式</label>
            <select class="form-select">
                <option selected>主路由（正常拨号上网）</option>
                <option>旁路由（仅网关/旁路模式）</option>
            </select>
        </div>
        <button class="btn-primary w-100 mt-3">确认切换模式</button>
    </div>
</div>
<%+footer%>
EOF

# --------------------------
# 菜单图标统一美化（全部带图标）
# --------------------------
uci batch <<EOF
set luci.menu.game.icon='icon-gamepad'
set luci.menu.repairnet.icon='icon-wrench'
set luci.menu.wifi.icon='icon-wifi'
set luci.menu.ipv6.icon='icon-globe'
set luci.menu.gateway.icon='icon-settings'
commit luci
EOF

exit 0
