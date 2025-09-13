# Renderデプロイガイド

## 必要な環境変数

Renderダッシュボードで以下の環境変数を設定してください：

### 必須の環境変数

1. **RAILS_MASTER_KEY**
   - 値: `config/master.key`ファイルの内容をコピー
   - セキュリティ上重要なため、他の人と共有しないでください

2. **DATABASE_URL**
   - Renderが自動で設定するため、手動設定は不要

3. **RAILS_ENV**
   - 値: `production`
   - render.yamlで自動設定済み

### オプション環境変数

4. **WEB_CONCURRENCY**
   - 値: `2` (Freeプランの推奨値)
   - render.yamlで設定済み

5. **BUNDLE_WITHOUT**
   - 値: `development:test`
   - render.yamlで設定済み

6. **RAILS_DEFAULT_URL_HOST**
   - 値: あなたのRenderアプリのドメイン（例: `your-app-name.onrender.com`）
   - Deviseのメール機能で必要

7. **RAILS_SERVE_STATIC_FILES**
   - 値: `true`
   - render.yamlで設定済み

8. **RAILS_LOG_TO_STDOUT**
   - 値: `true`
   - render.yamlで設定済み

## master.keyの確認方法

```bash
cat config/master.key
```

このコマンドで表示される文字列を`RAILS_MASTER_KEY`に設定してください。

## デプロイ時の注意事項

- Freeプランでは初回デプロイ完了まで15分程度かかる場合があります
- データベースマイグレーションは自動実行されます
- アセットプリコンパイルも自動実行されます

## トラブルシューティング

### デプロイが失敗する場合

1. ログを確認してエラー内容を特定
2. `RAILS_MASTER_KEY`が正しく設定されているか確認
3. Gemfileの依存関係に問題がないか確認

### データベース接続エラー

- `DATABASE_URL`がPostgreSQLサービスから正しく取得されているか確認
- PostgreSQLサービスが同じプロジェクト内にあるか確認