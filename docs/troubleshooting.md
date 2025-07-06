# トラブルシューティングガイド

## 🚫 Grafanaが起動しない（開発環境＆本番環境）

**症状**: `http://127.0.0.1` にアクセスできない  
**原因**: コンテナ起動直後で Grafana がまだ準備中  
**対処法**:
- 数秒待って再アクセスする
- `docker logs grafana` で起動状態を確認

---

## 🔐 NginxのSSL証明書が認識されない（本番環境）

**原因**: `/etc/nginx/conf.d/default.conf` に定義しているファイルパスと異なっている。  
**対処法**:
- SSL証明書のディレクトリは`/etc/letsencrypt/...`内を想定しています。
- Nginxの設定ファイルの中身を確認し、SSL証明書が配置されているディレクトリと同じファイルパスか：`sudo docker exec -it prod-nginx cat etc/nginx/conf.d/default.conf`

