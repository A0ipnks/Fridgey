# PWA実装ガイド

## 概要
Rails 7アプリケーションをPWA（Progressive Web App）対応し、スマートフォンでネイティブアプリのような体験を提供する実装手順。

## 実装済み機能
- Web App Manifest
- Service Worker（キャッシュ戦略）
- オフライン対応
- ホーム画面インストール対応

## ファイル構成
- `app/views/pwa/manifest.json.erb` - PWAマニフェスト
- `app/views/pwa/service_worker.js.erb` - サービスワーカー
- `config/routes.rb` - PWAルート設定
- `app/views/layouts/application.html.erb` - PWAメタタグ

## テスト方法
1. Chrome開発者ツール → Application → Manifest
2. Lighthouseでスコア確認
3. 実機でのインストールテスト