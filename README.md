# CMCC_A10 路由器固件编译仓库

本仓库用于编译中国移动 CMCC_A10（AX3000 Wi‑Fi 6，MT7981B 芯片）路由器的 OpenWrt/ImmortalWrt 固件，支持 GitHub Actions 云端一键编译。

## 硬件信息
- **型号**：中国移动 CMCC_A10
- **芯片**：MT7981B（双核 A53 1.3GHz）
- **内存**：256MB DDR4
- **闪存**：128MB NAND Flash
- **无线**：2.4GHz + 5GHz Wi‑Fi 6

## 目录结构

## 快速开始

### 1. 云端编译（推荐）
1. 点击右上角 **Fork**，将本仓库 Fork 到你的 GitHub 账号。
2. 进入你 Fork 后的仓库，点击 **Actions** → 同意启用 Actions。
3. 编辑 `.config`、`diy-part1.sh`、`diy-part2.sh` 定制固件。
4. 提交代码到 `main` 分支，自动触发编译任务。
5. 编译完成后，在 Actions 页面的 **Artifacts** 中下载固件。

### 2. 本地编译
```bash
# 克隆仓库
git clone https://github.com/luanmuc/CMCC_A10.git
cd CMCC_A10

# 拉取 ImmortalWrt 源码
git clone https://github.com/immortalwrt/immortalwrt.git
cd immortalwrt

# 应用自定义脚本
cp ../.config .config
cp ../diy-part1.sh ./
cp ../diy-part2.sh ./
bash diy-part1.sh
bash diy-part2.sh

# 开始编译
make -j$(nproc)
