## アプリの説明
このアプリは、買い出し時にカゴの中に入れた商品の金額をメモするためのアプリです。

アプリURL: https://shopping-memo.fly.dev/
スマートフォンでの閲覧を推奨
スマートフォンでは下記URLを読み込むとアクセスできます

![](app/assets/images/shopping_memo_qr.png)

## ローカル環境構築手順

### このリポジトリをクローンする
- `git clone git@github.com:yuta-saito-0310/shopping_app.git`をしてリポジトリをホストマシンに取り込みます
- `cd shopping_app/ && code .`でアプリのフォルダーを開きます

### .envファイルを用意する
- `cp .env.dev.sample .env.dev`で環境変数ファイルを用意します

### 開発コンテナを立ち上げる
#### Dev Containersを入れている場合
VS Codeの拡張機能の[Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)を利用している場合は、`Crtl + Shift + P` または`Command + Shift + P`からコマンドパレットを開き、`Rebuild and Reopen in Container`を選択して開発コンテナを立ち上げます

#### Dev Containersを入れていない場合
Dev Containersを入れていない場合は、docker composeを利用してコンテナを立ち上げます
- `cd .devcontainer`で開発コンテナ用のdocker-compose.ymlが記載されているフォルダーに移動します
- `docker compose up -d`で開発コンテナを立ち上げます。コンテナがうまく立ち上がっていない時は`docker compose up`で失敗原因を探していきます
- `docker compose exec web /bin/bash`で開発コンテナに入ります

### gemをインストールする
- `bundle install`をコンテナ内で実行して必要なgemをインストールします

### tailwindcssをビルドする
- `rails tailwindcss:build`でCSSをビルドします

### dbをセットアップする
- `rails db:setup`でDBを作成します

### サーバーを立ち上げる
- `rails s`でサーバーを立ち上げ、localhost:3000にアクセスします

## テストの実行方法
- `bundle exec rspec`でテストを実行できます
- PRを出した際もRSpecが実行されます

## デプロイ方法
- mainブランチにマージされると、自動的にデプロイされます