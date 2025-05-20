#!/bin/bash
# run docker container prometheus and node-exportger
# 2025/5/17
# 実行コマンド
# 「./docker_prom_node.sh」

# Prometheusコンテナ
docker run --name prometheus \
  --network mynetwork \
  -v ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
  -d -p 127.0.0.1:9090:9090 \
  prom/prometheus


# Node Exporterコンテナ（-pオプションを設定するとhost.docker.internal:9100で接続できるが開発環境のみ）
# /procや/sysとすることで必要最低限のリソース情報をマウントするのでセキュリティリスクが低くなる。
docker run --name node -d \
  --network mynetwork \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  quay.io/prometheus/node-exporter:latest \
  --path.rootfs=/host # Node Exporterのオプション設定
# -p 9100:9100 \

# Node Exporterコンテナ（公式ドキュメントの設定だが、セキュリティ的に問題あり）
# docker run --name node -d \
#   --net=host \ # ホスト上のネットワークリソースをコンテナでも使用できるようにする
#   --pid=host \ # ホストのPID（プロセスID）をコンテナから使用する
#   -v /:/host:ro,rslave \ # ホスト上のルートディレクトリ（/）をマウントする
#   quay.io/prometheus/node-exporter:latest \
#   --path.rootfs=/host # Node Exporterのオプション設定で、メトリクスを収集するルートファイル（rootfs）の設定

