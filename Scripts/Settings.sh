#!/bin/bash
set -e

# 红米 AX6000 编译设置扩展入口。
# WRT-CORE 会先加载所选上游的 defconfig/mt7986-ax6000.config，
# 再依次叠加 Config/Redmi-AX6000.txt、GENERAL.txt、PRIVATE.txt。

# OpenSSH 8.4 / openwrt-21.02：首启时直接修改 sshd_config，
# 允许 root 登录并开启密码认证，避免依赖 sshd_config.d Include 支持。
mkdir -p ./package/base-files/files/etc/uci-defaults
cat > ./package/base-files/files/etc/uci-defaults/99-openssh-root <<'EOF'
#!/bin/sh

SSHD_CONFIG="/etc/ssh/sshd_config"
[ -f "$SSHD_CONFIG" ] || exit 0

if grep -qE '^[#[:space:]]*PermitRootLogin[[:space:]]+' "$SSHD_CONFIG"; then
    sed -i -E 's|^[#[:space:]]*PermitRootLogin[[:space:]].*|PermitRootLogin yes|' "$SSHD_CONFIG"
else
    echo 'PermitRootLogin yes' >> "$SSHD_CONFIG"
fi

if grep -qE '^[#[:space:]]*PasswordAuthentication[[:space:]]+' "$SSHD_CONFIG"; then
    sed -i -E 's|^[#[:space:]]*PasswordAuthentication[[:space:]].*|PasswordAuthentication yes|' "$SSHD_CONFIG"
else
    echo 'PasswordAuthentication yes' >> "$SSHD_CONFIG"
fi

exit 0
EOF
chmod +x ./package/base-files/files/etc/uci-defaults/99-openssh-root
