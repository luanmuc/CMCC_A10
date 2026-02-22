#!/bin/bash

# 插件源
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default

# Argon 主题
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# 插件商店
git clone --depth=1 https://github.com/linkease/istore.git package/istore
git clone --depth=1 https://github.com/linkease/luci-app-store.git package/luci-app-store
