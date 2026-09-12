# Redmi AX6000 ImmortalWrt CI

用于红米 AX6000（MT7986）闭源驱动 ImmortalWrt 固件的 GitHub Actions 云编译。

## 上游源码

当前支持在 Actions 中选择：

- `padavanonly/immortalwrt-mt798x`，分支 `openwrt-21.02`
- `hanwckf/immortalwrt-mt798x`，分支 `openwrt-21.02`
- `both`：同时编译以上两个上游

编译时会先读取当前所选上游自己的 `defconfig/mt7986-ax6000.config`，继承该上游对应的 MT7986 闭源 Wi-Fi、WED、WARP 等配置，再叠加本仓库的精简配置。因此两个上游可以共用同一套本地配置，同时保留各自驱动差异。

## 使用

进入 `Actions -> MTK-ALL -> Run workflow`，选择上游源码后运行即可。需要调试时可开启 SSH。

## 配置结构

- `Config/Redmi-AX6000.txt`：只保存 MT7986 与 Redmi AX6000 的设备选择
- `Config/GENERAL.txt`：两个上游共用的构建配置
- `Config/PRIVATE.txt`：私人插件及功能选择
- `Scripts/Packages.sh`：第三方软件包扩展
- `Scripts/Handles.sh`：源码修正扩展
- `Scripts/Settings.sh`：系统设置扩展
- `.github/workflows/MTK-ALL.yml`：编译入口与上游选择
- `.github/workflows/WRT-CORE.yml`：公共编译核心
- `.github/workflows/Auto-Clean.yml`：旧 Release / workflow 清理
- `.github/workflows/Cache-Clean.yml`：构建缓存清理

最终完整 `.config` 会在每次编译后随固件一起上传，Release 页面同时显示实际进入固件的 LuCI 插件与主题列表。

## U-Boot

参考：`hanwckf/bl-mt798x`
