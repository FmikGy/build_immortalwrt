# Redmi AX6000 ImmortalWrt CI

用于红米 AX6000（MT7986）闭源驱动 ImmortalWrt 固件的 GitHub Actions 云编译。

## 上游源码

当前支持在 Actions 中选择：

- [`padavanonly/immortalwrt-mt798x`](https://github.com/padavanonly/immortalwrt-mt798x)，分支 `openwrt-21.02`
- [`hanwckf/immortalwrt-mt798x`](https://github.com/hanwckf/immortalwrt-mt798x)，分支 `openwrt-21.02`
- `both`：同时编译以上两个上游

编译时会先读取当前所选上游自己的 `defconfig/mt7986-ax6000.config`，继承该上游对应的 MT7986 闭源 Wi-Fi、WED、WARP、HNAT 等配置，再叠加本仓库的精简配置。因此两个上游可以共用同一套本地配置，同时保留各自驱动与固件差异。

选择 `both` 时，两个上游分别在独立 GitHub Actions Job 中构建，各自使用自己的源码、`mt7986-ax6000.config`、缓存、Artifact 与 Release，不会互相覆盖。

## 固件布局

每个上游都会同时编译：

- `xiaomi_redmi-router-ax6000`：普通布局
- `xiaomi_redmi-router-ax6000-stock`：stock 原厂分区布局

上游当前只为普通布局定义 `factory.bin`；stock 布局生成对应的 `sysupgrade.bin`。不同布局的固件不要混用。

## 私人插件

仅额外加入：

- `luci-app-openclash`

OpenClash 源码来自 [`vernesong/OpenClash`](https://github.com/vernesong/OpenClash) 的 `dev` 分支。

## 系统与管理组件

两个上游统一加入以下系统管理配置：

- 使用 `openssh-server` 替代 Dropbear
- 安装 `openssh-keygen`
- 安装 `openssh-sftp-server`
- 禁用 `dropbear`
- 允许 root 通过 OpenSSH 登录
- 开启 OpenSSH 密码认证
- `uhttpd` / `uhttpd-mod-ubus` / `luci-app-uhttpd`
- `ttyd` / `luci-app-ttyd`
- `luci-app-ddns`

OpenSSH 的 root 密码登录要求设备上的 root 已设置非空密码。

## opkg 软件源

固件首次启动时会自动把 `/etc/opkg/distfeeds.conf` 中的：

- `https://downloads.immortalwrt.org`
- `https://mirrors.vsean.net/openwrt`

统一替换为：

- `https://mirrors.pku.edu.cn/immortalwrt`

修改时使用 `sed -i.bak`，原始配置会保留为备份文件。

## 使用

进入 `Actions -> MTK-ALL -> Run workflow`，选择上游源码后运行即可。需要调试时可开启 SSH。

## 配置结构

- `Config/Redmi-AX6000.txt`：保存 MT7986 与 Redmi AX6000 双布局设备选择
- `Config/GENERAL.txt`：两个上游共用的构建配置，包括 OpenSSH、uHTTPd、TTYD、DDNS 等
- `Config/PRIVATE.txt`：私人插件选择，目前仅 OpenClash
- `Scripts/Packages.sh`：第三方软件包扩展，目前负责加入 OpenClash
- `Scripts/Handles.sh`：源码修正扩展
- `Scripts/Settings.sh`：系统设置扩展，包括 OpenSSH root 登录与 opkg 北大镜像切换
- `.github/workflows/MTK-ALL.yml`：编译入口与上游选择
- `.github/workflows/WRT-CORE.yml`：公共编译核心
- `.github/workflows/Auto-Clean.yml`：旧 Release / workflow 清理
- `.github/workflows/Cache-Clean.yml`：构建缓存清理

最终完整 `.config` 会在每次编译后随固件一起上传，Release 页面同时显示实际进入固件的 LuCI 插件与主题列表。

## U-Boot

参考：[`hanwckf/bl-mt798x`](https://github.com/hanwckf/bl-mt798x)
