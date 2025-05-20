#!/bin/bash
# run docker container prometheus
# 2025/5/17
# 実行コマンド
# 「./docker_prom.sh」

# Prometheusコンテナ
docker run --name prometheus \
  -v ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
  -d -p 127.0.0.1:9090:9090 \
  prom/prometheus

