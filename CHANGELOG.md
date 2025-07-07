# CHANGELOG.md

## v1.1.1 - SSL証明書がNginxコンテナで読込不可になる件

- dev-nginxでSSL自己証明書が読み込めないというエラーで、SSL自己証明書の設定を廃止にしました。nginx/conf.d/dev.confのhttps（443）ブロックの削除とcompose.ymlでのマウントを修正。


## アジャイル開発プロセスの振り返りレポート

- 以下のファイルを新規作成

```
├── .github
│   ├── pull_request_template.md
├── docs
│   ├── retrospectives
```

- .github/pull_request_template.md：Pull Request用のテンプレート
- docs/retrospectives：スプリントの振り返りレポートを管理するディレクトリ

## v1.0.1 - マイナーチェンジ

トラブルシューティングガイドやバージョン情報の確認に伴う変更

- CHANGELOG.mdの作成
- Makefileの作成
- README.mdの修正
- doc/troubleshooting.mdの作成
- setup.shの作成

## v1.0.0 - 初回リリース

このバージョンでは以下の構成と機能を含みます：

### 🔧 技術スタック
- Grafana + Prometheus + Node Exporter による監視構成
- Nginx リバースプロキシを含む Docker Compose による環境構築

### 🧪 開発環境
- ローカルでの CPU負荷テストと監視ダッシュボードの確認
- サンプル `.env` テンプレートを同梱

### 🚀 本番環境対応
- `.env` による環境変数管理の導入
- SSL証明書の設定手順（Nginx）に関する注意喚起
