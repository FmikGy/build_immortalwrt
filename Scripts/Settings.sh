#!/bin/bash
set -e

# 红米 AX6000 编译设置扩展入口。
# WRT-CORE 会先加载所选上游的 defconfig/mt7986-ax6000.config，
# 再依次叠加 Config/Redmi-AX6000.txt、GENERAL.txt、PRIVATE.txt。
# 需要修改默认 IP、主机名、密码等设置时可继续在这里扩展。

true
