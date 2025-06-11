#!/bin/bash
# run test workflow
# 2025/6/10
# 実行コマンド
# 「'source act_run.sh' or '. act_run.sh'」

# GitHub Actionsのワークフローをactを使ってローカルでテスト実行する
#
# $ brew install act
#
# actを実行するの為.bash_profileに以下を設定
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#
#　設定を反映する
# $ source ~/.bash_profile


# 1.====================================
# 環境変数を設定する
# - if文で環境変数に値があるかチェック
# - 環境変数に値が無ければ対話モードのreadで挿入
# ======================================

echo "変数のチェックをします============"

# 1.ACT_SSH_KEYにプライベートキー
if [ -z "${ACT_SSH_KEY}" ]; then
  echo "ACT_SSH_KEYは空なので作成します。"
  ACT_SSH_KEY="$(cat ~/.ssh/id_rsa)"
else
  echo "ACT_SSH_KEYは作成済みです。"
fi

# 2.ACT_SSH_PORTにポート番号
if [ -z "${ACT_SSH_PORT}" ]; then
  echo "ACT_SSH_PORTは空なので作成します。"
  read ACT_SSH_PORT
  declare -i ACT_SSH_PORT
  export ACT_SSH_PORT
else
  echo "ACT_SSH_PORTは作成済みです: ${ACT_SSH_PORT}"
fi

# 3.ACT_SSH_USERにユーザー名
if [ -z "${ACT_SSH_USER}" ]; then
  echo "ACT_SSH_USERは空なので作成します。"
  read ACT_SSH_USER
  export ACT_SSH_USER
else
  echo "ACT_SSH_USERは作成済みです: ${ACT_SSH_USER}"
fi

# 4.ACT_SSH_DOMAINにドメイン
if [ -z "${ACT_SSH_DOMAIN}" ]; then
  echo "ACT_SSH_DOMAIN空なので作成します。"
  read ACT_SSH_DOMAIN
  export ACT_SSH_DOMAIN
else
  echo "ACT_SSH_DOMAINは作成済みです: ${ACT_SSH_DOMAIN}"
fi

# 5.ACT_SUDO_PASSに本番環境のsudoパス
if [ -z "${ACT_SUDO_PASS}" ]; then
  echo "ACT_SUDO_PASSは空なので作成します。"
  read ACT_SUDO_PASS
  export ACT_SUDO_PASS
else
  echo "ACT_SUDO_PASSは作成済みです: ${ACT_SUDO_PASS}"
fi


# 2.====================================
# actの実行
# - actのオプションに各変数を設定
# ======================================

echo "actを実行します==================="

act -s SSH_KEY="${ACT_SSH_KEY}" -s SSH_PORT="${ACT_SSH_PORT}" -s SSH_DOMAIN="${ACT_SSH_DOMAIN}" -s SSH_USER="${ACT_SSH_USER}" -s SUDO_PASS="${ACT_SUDO_PASS}"
