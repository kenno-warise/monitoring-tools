#!/bin/bash
# run Docker setup
# 2025/6/9
# 実行コマンド
# 「./setup.sh」

# GitHub Actionsのワークフローが実行されたら以下の処理を順次実行する。

# 1.====================================
# 
# - ルートのマウントの伝播タイプの確認をして、privateだったらsharedに変更。
# - この設定をしないと、コンテナはホストと情報の共有をできない（Node Expoterのコンテナが立ち上がらない）。
#
# grepした結果が空だったら、mountコマンドでrsharedに変更。
# ======================================
# 
# ルートのマウントの伝播タイプをsharedに変更
# sudo mount --make-rshared /
#

echo "ルートマウントの伝播タイプがsharedであるか確認します。もし異なった場合はルートマウントの伝播タイプをsharedに変更します。"

root_mount_type=$(findmnt -o TARGET,PROPAGATION / | grep shared)

if [ -z "$root_mount_type" ]; then
  echo "伝播タイプをrsharedに変更"
  mount --make-rshared /
fi

echo "==ルートマウントの伝播タイプ=="
findmnt -o TARGET,PROPAGATION /


# 2.====================================
#
# - 開発環境用と本番環境用でセットアップを分ける。
#
# ======================================

home_dir=$HOME
user_name=$USER

echo $home_dir
echo $user_name

echo "ホームディレクトリは？"
read read_home

if [ "$home_dir" = "$read_home" ]; then
  echo "$home_dir == $read_home"
fi
