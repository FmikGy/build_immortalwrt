#!/bin/bash
set -e

# 红米 AX6000 软件包扩展入口。
# 私人插件仅加入 OpenClash。

UPDATE_PACKAGE() {
    local PKG_NAME="$1"
    local PKG_REPO="$2"
    local PKG_BRANCH="$3"
    local PKG_SPECIAL="$4"
    local REPO_NAME="${PKG_REPO#*/}"

    find ../feeds/luci/ ../feeds/packages/ -maxdepth 3 -type d -iname "*${PKG_NAME}*" -prune -exec rm -rf {} + 2>/dev/null || true

    rm -rf "$REPO_NAME"
    git clone --depth=1 --single-branch --branch "$PKG_BRANCH" "https://github.com/${PKG_REPO}.git"

    if [[ "$PKG_SPECIAL" == "pkg" ]]; then
        find "./$REPO_NAME" -maxdepth 4 -type d -iname "*${PKG_NAME}*" -prune -exec cp -rf {} ./ \;
        rm -rf "$REPO_NAME"
    fi
}

UPDATE_PACKAGE "openclash" "vernesong/OpenClash" "dev" "pkg"
