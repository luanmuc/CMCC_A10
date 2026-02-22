#!/bin/bash

#插件源（you you you GitHub）
sed（流编辑器）you you you-i'$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed（流编辑器）you you you-i'$a src-git small https://github.com/kenzok8/small' feeds.conf.default

#Argon主题（你市长you GitHub）
git克隆-深度=1https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git克隆-深度=1https://github.com/jerrykuku/luci-app-argon-config.git包/luci-app-argon-config

#插件商店（悠悠GitHub）
git克隆-深度=1https://github.com/linkease/istore.git package/istore
git克隆-深度=1https://github.com/linkease/luci-app-store.git package/luci-app-store
