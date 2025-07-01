# 気づいた事や課題をメモ

## 2025-6-28

- 初期のダッシュボードページでパネルにグラフを表示させるには、JSONファイルのUIDに予めデータソースのUIDと紐づく値を定義しておく必要がある。UIDはデータソーステンプレートに自分で好きな英数字の文字列を定義して、そのUIDをダッシュボードテンプレートへsedコマンドを使って一括で置き換える。
- プロビジョニングでのテンプレートでは、UIDを固定にすることでダッシュボードのパネルが初期時でもグラフが表示されるようになる。そうなってくると、--inputsブロックの有効性は何何だろうと気になる。

## 2025-6-27

次回のスクリプトで開発する予定項目

- Grafanaのデータソースやダッシュボードはyamlやjsonファイルで予め設定を定義できる。
- Ansibleでインフラ構築？

## 2025-6-21

Grafanaのデータソースなどのファイル設定。

## 2025-6-20

- grafanaコンテナは環境変数を設定しても、処理順の都合上によりコンテナ内のgrafana.iniに設定が反映されるわけではない。よってcompose.yml等の環境変数に設定しておけば適応されるはず。確認方法はdocker exec -it grafana envでセルフで設定した環境変数一覧。

GF_STMP_ENABLEをGF_STMP_ENABLEDに変更してメール送信成功。

## 2025-6-17

- Grafanaのアラート設定にSMTPの設定でハマる

compose.ymlのenvironmentに設定できるであろう（公式側もそのように設定している）環境変数を設定してコンテナをダウンして実行しても、grafanaコンテナ内のgrafana.iniにSMTPの設定が反映されずメールの送信ができない。

- 試したこと
  - 直接grafanaコンテナのgrafana.iniのsmtp項目を編集しても読み取り専用だったため一旦諦める。
  - 環境変数の定義を: GF_SMTP_...: xxxxから- GF_SMTP_...=xxxxに変更して起動。でも駄目。
  - Dockerの管理ボリュームにあるgrafana.dbで何かしらの設定が保存されている可用性をみて一旦ボリュームを削除して再度コンテナをダウンして起動。これもダメ。
  - compose.ymlに設定したイメージをgrafana-ossからgrafana:latestにしても駄目。


## 2025-6-15

ワークフローのrsyncコマンドで差分転送する際に除外する候補のファイル群はリポジトリを更新するたびに除外候補を作成するか検討。

### 本番環境のNginxに許可したIPアドレスを動的に更新する流れ

スクリプト（update_ip.sh）の作成

```script
#!/bin/bash

IP=$(curl -s ifconfig.me)
ssh -p 2222 user@server "echo 'allow $IP;' | sudo tee /etc/nginx/conf.d/ip_whitelist.conf && sudo systemctl reload nginx"
```

実行権限を付与

```bash
$ chmod +x update_ip.sh
```

crontabを開いて追記

```
$ crontab -e
```

以下を追記

```
@reboot /path/to/update_ip.sh
```

PCが起動される度に上記のスクリプトが実行される。

## 2025-6-13

### 自動化スクリプトの作成

問題：本番環境でdocker compose downしてからdocker compose up -dするとグラフデータがリセットされてしまう。ダッシュボードは無事。恐らくPrometheus側のデータがリセットされているだけ。

- 一般的には本番環境でgitは使用しない。
- 本番環境へ新規でリポジトリを転送する場合はscp、差分更新の場合はrsyncを使う。
- 初回本番環境でのセットアップは手動による環境変数等の設定が必要。次回から自動化デプロイ。
- 小規模や人命に関わらないようなシステムの場合はリリースの自動化ケースもある。
- 機密情報はActionsのSecretsに登録

## 2025-6-7

### 自動化スクリプトで必要な資料

prod.confの一括処理コード
処理方法は過去のログを確認
- free-domain
- ip-address
- ssl-domain


- GrafanaとBacik認証の初期設定
- .envはどのように活用するか（sshやsecret等の機密ファイル群が散らかっているのでまとめたい。）
- CI/CDの作成


## 2025-6-3

### データベース間のデータの移行（sqlite3）

特定のテーブル内のデータを取得して、同じテーブルを持つデータに上書きする。

```
$ sqlite3 grafana.db .dump | grep 'INSERT INTO テーブル名' > table.sql

$ sqlite3 source.db < table.sql
```


### WSL内のボリュームマウントの配置場所

```
$ powershell.exe

PS C\:ls \\wsl.localhost\docker-desktop\mnt\docker-desktop-disk\data\docker\volumes
monitoring_grafana_data ...
```

## 2025-6-3

### Grafanaコンテナ実行時の/var/lib/grafanaの権限について

/var/lib/grafanaディレクトリは権限がバインドマウントのディレクトリには無いのでdocker起動時にエラーとなる。
回避するにはネームドマウントを作成すること。これはdocker自体のディレクトリに管理されるので権限はホストと同等な種類となる。
よって問題無く処理される。

```yml

services:
  grafana:
    volumes:
      - grafana_data:/var/lib/grafana

volumes:
  grafana_data:

```

バインドマウントで権限を付与したい場合は、chownコマンドで権限を与える。

```bash
$ ls
docker-compose.yml grafana_data ...

$ sudo chown -R 472:472 grafana_data
```

```yml

services:
  grafana:
    volumes:
      - ./grafana_data:/var/lib/grafana

```

## 2025-5-28 -- 2025-5-31

### 開発環境から本番環境へのデータ移行手順の確立

- 今のところ
 - スクリプトファイルにBasic認証ファイルの作成、prod.confのIPアドレスとフリードメイン名とletencryptディレクトリのドメイン名の設定を一括処理する。
 - .envファイルを作成して、環境変数の設定をする（Grafanaの初回ログイン用）。

.envファイルの内容

```
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=supersecurepassword
GRAFANA_ROOT_URL=https://grafana.example.com/
```
初回ログイン時なので、一度簡単なパスワードでログインされた後に、アカウント設定で強力なパスワードにすればそれでよし。
URLはNginxのserver_nameに定義したドメインを設定する。

以下のように定義すると.envファイルの環境変数が適用される。

```
# 例
services:
  grafana:
    image: grafana/grafana
    environment:
      - GF_SECURITY_ADMIN_USER=${GRAFANA_ADMIN_USER}
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}
      - GF_SERVER_ROOT_URL=${GRAFANA_ROOT_URL}
```


Basic認証の作成。-1オプションはハッシュ化アルゴリズムでMD5ベースのハッシュで暗号化される。

```shell
$ echo "you-are-name:$(openss passwd -1 'your-password')" >> .htpasswd
```

ファイル内の要素を置き換える。-iオプションで書き換えする。.bakを付けることでファイルをバックアップしてくれる。

```shell
$ sed -i.bak "s/元の要素/新要素/g" filename.conf
```

複数の要素を置き換えたいとき

```shell
$ sed -i -e "s/元の要素/新要素/g" -e "s/orld/new/g" filename.conf

$ sed -i "s/元の要素/新要素/g; s/orld/new/g" filename.conf
```

- 開発環境ではnginxコンテナを構築するが、本番環境ではホスト側のnginxからリバースプロキシを行う。

```shell
$ cp nginx/conf.d/prod.conf /etc/nginx/conf.d/.
```

---
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

---
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
