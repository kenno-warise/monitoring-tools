#!/bin/bash
# run docker container nginx
# 2025/5/7
# 実行コマンド
# 「./docker_nginx.sh」

# networkの作成
docker network create mynetwork

# HTMLをホストするバックエンドサービス
docker run --name backend -v ./mysite:/usr/share/nginx/html --network mynetwork -d nginx:latest

# Nginxの設定ファイルを元にリバースプロキシを実行
docker run --name nginx -v ./conf.d/default.conf:/etc/nginx/conf.d/default.conf --network mynetwork -d -p 80:80 nginx:latest
