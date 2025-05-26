#!/bin/bash
# run root mount position type change shared
# 2025/5/26
# 実行コマンド
# 「./mount_change.sh」

# ルートのマウントの伝播タイプをsharedに変更
sudo mount --make-rshared /

# ルートのマウントの伝播タイプの確認
findmnt -o TARGET,PROPAGATION /
