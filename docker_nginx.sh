#!/bin/bash
# run docker container nginx
# 2025/5/7
# 実行コマンド
# 「./docker_nginx.sh」

# echo 'Hello Nginx'
docker run --name nginx -v ./mysite:/usr/share/nginx/html:ro -d -p 8080:80 nginx:latest
