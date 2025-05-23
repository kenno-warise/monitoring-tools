#!/bin/bash
# run docker container nginx and grafana
# 2025/5/23
# 実行コマンド
# 「./docker_grafana_nginx.sh」

# Prometheusコンテナ
docker run --name prometheus \
  --network mynetwork \
  -v ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
  -d -p 127.0.0.1:9090:9090 \
  --restart unless-stopped \
  prom/prometheus

# Node Exporterコンテナ（-pオプションを設定するとhost.docker.internal:9100で接続できるが開発環境のみ）
# /procや/sysとすることで必要最低限のリソース情報をマウントするのでセキュリティリスクが低くなる。
docker run --name node -d \
  --network mynetwork \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  --restart unless-stopped \
  quay.io/prometheus/node-exporter:latest \
  --path.rootfs=/host # Node Exporterのオプション設定

# Grafanaコンテナ
docker run --name grafana \
  --network mynetwork \
  -v ./grafana/data:/var/lib/grafana \
  --restart unless-stopped \
  -d -p 3000:3000 \
  grafana/grafana-oss

# Nginxの設定ファイルを元にリバースプロキシを実行
docker run --name nginx \
  -v ./secret/ssl:/etc/ssl \
  -v ./secret/.htpasswd:/etc/nginx/.htpasswd \
  -v ./nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf \
  --network mynetwork \
  -d -p 80:80 -p 443:443 \
  nginx:latest

