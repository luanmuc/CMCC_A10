#!/bin/bash

# 插件源（适配 immortalwrt，改用镜像）
sed -i '$a src-git kenzo https://github.com.cnpmjs.org/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com.cnpmjs.org/kenzok8/small' feeds.conf.default

# Argon 主题 (使用 CNPM 镜像克隆，避免认证错误)
git clone --depth=1 https://github.com.cnpmjs.org/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 https://github.com.cnpmjs.org/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# 插件商店 (使用 CNPM 镜像克隆，避免认证错误)
git clone --depth=1 https://github.com.cnpmjs.org/linkease/istore.git package/istore
git clone --depth=1 https://github.com.cnpmjs.org/linkease/luci-app-store.git package/luci-app-store
