# 気づいた事や課題をメモ

## 2025-5-27

- docker-compose.ymlのnginxコンテナを開発用と本番用に分けたので、コマンド実行時は--profile=dev,prodを付与する。

開発環境でのコンポース実行

```shell
$ docker compose --profile dev up -d
```

コンテナを停止して削除するとき

```shell
$ docker compose --profile dev down
```

## 2025-5-25

- Grafnaのダッシュボード作成で、CPU、Memory、Diskの使用率をグラフで表示する際に、Diskのメトリクスを取得するためのnode_filesystem_...がホストOSからしっかり取得できていなかったので、ボリュームマウントを変更してホスト側のマウントの伝播タイプを変更。
- 結果的に、node-expoter公式ドキュメント通りの設定（-v /:/host:ro,rslaveが重要）。

伝播タイプprivateからsharedに変更

```shell
$ sudo mount --make-rshared /
```

現在の伝播タイプを確認

```shell
findmnt -o SOURCE,TARGET,PROPAGATION /
```

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
