# 気づいた事や課題をメモ

- Nginxの設定ファイルでは、開発環境はopensslの自己証明書、本番環境はLet's EncryptのSSL証明書を各自で利用するので気を付ける。
- 本番環境ではLet's Encryptを更新する際、.well-known/...を参照するので、マウントする際に気を付ける。


本番環境で設定するnginxのdefault.conf
```Nginx
server {
    listen 80 default_server;
    server_name IPアドレス さくらのドメイン;
    return 301 https://さくらのドメイン/$request_uri;
}

server {
    listen 443 ssl ;
    server_name さくらのドメイン;
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem; # Let's Encryptで取得したSSL証明書のパス。
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem; # SSL証明書の秘密鍵のパス。
    location /.well-known/acme-challenge/ {
        root /var/www/さくらのドメイン;
    }
    location / {
        proxy_pass http://localhost:xxxxx; # Grafanaのポート番号
        proxy_set_header Host さくらのドメイン;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```
