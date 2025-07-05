#!/bin/bash

# setup.sh 内部で最新リリース確認（オプション）
LATEST=$(curl -s https://api.github.com/repos/kenno-warise/monitoring-tools/releases/latest | grep '"tag_name":' | awk -F'"' '{print $4}')
CURRENT="v1.0.0"

# if [ "$LATEST" >= "$CURRENT" ]; then
#   echo "🔔 新しいバージョン $LATEST が利用可能です！"
# fi

# バージョン番号だけ取り出す（先頭のvを削除）
VER_LATEST="${LATEST#v}"
VER_CURRENT="${CURRENT#v}"

if [ "$(printf '%s\n' "$VER_CURRENT" "$VER_LATEST" | sort -V | head -n1)" != "$VER_LATEST" ]; then
  echo "🔔 新しいバージョン $LATEST が利用可能です！"
else
  echo "✅ 現在のバージョン $CURRENT は最新です"
fi
