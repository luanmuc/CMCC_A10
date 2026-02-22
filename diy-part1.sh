#!/bin/bash

# 插件源（适配 immortalwrt，改用 fastgit 镜像）
sed -i '$a src-git kenzo https://hub.fastgit.xyz/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://hub.fastgit.xyz/kenzok8/small' feeds.conf.default

# Argon 主题 (使用 fastgit 镜像克隆)
git clone --depth=1 https://hub.fastgit.xyz/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 https://hub.fastgit.xyz/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# 插件商店 (使用 fastgit 镜像克隆)
git clone --depth=1 https://hub.fastgit.xyz/linkease/istore.git package/istore
git clone --depth=1 https://hub.fastgit.xyz/linkease/luci-app-store.git package/luci-app-store
