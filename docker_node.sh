#!/bin/bash
# run docker container node-exporter
# 2025/5/17
# 実行コマンド
# 「./docker_node.sh」

# Node Exporterコンテナ
docker run --name node -d \
  --net=host \
  --pid=host \
  -v ./:/host:ro,rslave \
  quay.io/prometheus/node-exporter:latest \
  --path.rootfs=/host

