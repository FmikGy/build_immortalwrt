# Redmi AX6000 ImmortalWrt CI

用于红米 AX6000（MT7986）闭源驱动 ImmortalWrt 固件的 GitHub Actions 云编译。

## 上游源码

当前支持在 Actions 中选择：

- `padavanonly/immortalwrt-mt798x`，分支 `openwrt-21.02`
- `hanwckf/immortalwrt-mt798x`，分支 `openwrt-21.02`
- `both`：同时编译以上两个上游

## 使用

进入 `Actions -> MTK-ALL -> Run workflow`，选择上游源码后运行即可。需要调试时可开启 SSH。

## 目录结构

- `Config/Redmi-AX6000.txt`：红米 AX6000 编译配置
- `Scripts/Packages.sh`：第三方软件包扩展
- `Scripts/Handles.sh`：源码修正扩展
- `Scripts/Settings.sh`：编译设置扩展
- `.github/workflows/MTK-ALL.yml`：编译入口与上游选择
- `.github/workflows/WRT-CORE.yml`：公共编译核心
- `.github/workflows/Auto-Clean.yml`：旧 Release / workflow 清理
- `.github/workflows/Cache-Clean.yml`：构建缓存清理

## U-Boot

参考：`hanwckf/bl-mt798x`
