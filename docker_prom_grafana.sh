#!/bin/bash
# run docker container prometheus and grafana
# 2025/5/21
# 実行コマンド
# 「./docker_prom_grafana.sh」

# Prometheusコンテナ
docker run --name prometheus \
  --network mynetwork \
  -v ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
  -d -p 127.0.0.1:9090:9090 \
  --restart unless-stopped \
  prom/prometheus

# Grafanaコンテナ
docker run --name grafana \
  --network mynetwork \
  -v ./grafana/data:/var/lib/grafana \
  -d -p 3000:3000 \
  --restart unless-stopped \
  grafana/grafana-oss


# Node Exporterコンテナ（-pオプションを設定するとhost.docker.internal:9100で接続できるが開発環境のみ）
# /procや/sysとすることで必要最低限のリソース情報をマウントするのでセキュリティリスクが低くなる。
docker run --name node -d \
  --network mynetwork \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  --restart unless-stopped \
  quay.io/prometheus/node-exporter:latest \
  --path.rootfs=/host # Node Exporterのオプション設定
