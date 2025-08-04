# Fridgey - 冷蔵庫管理アプリ

家族で使える冷蔵庫内管理アプリ。食材の管理と賞味期限の追跡を簡単に行えます。

## 機能

* ユーザー認証（Devise）
* 冷蔵庫（Room）の作成・管理
* 食材（Food Item）の登録・編集・削除
* 賞味期限の管理
* レスポンシブデザイン（Tailwind CSS）

## 技術スタック

* Ruby 3.3.0
* Rails 7.2.1
* SQLite3（開発環境）
* Tailwind CSS
* Stimulus.js
* Turbo

## セットアップ

```bash
# 依存関係のインストール
bundle install

# データベースの作成とマイグレーション
rails db:create
rails db:migrate

# 開発サーバーの起動
bin/dev
```

## プロジェクト概要

### アプリ名
Fridgey(フリッジー)

### コンセプト
冷蔵庫内の食材把握PWAアプリ

### 目的・課題解決
- 食材の重複購入による無駄な出費を防止
- 家族間での食材使用状況のリアルタイム共有
- 夕食準備時の「食材がない」トラブルの解消
- 食品ロスの削減
- 使用制限タグによる食材の用途管理

## 2. ターゲットユーザー

### 主要ターゲット
- 家族世帯（2人以上の世帯）
- 共働き世帯
- シェアハウス住人
- 食費を節約したい世帯
- スマートフォンを日常的に使用するユーザー

### 副次ターゲット
- 一人暮らしで計画的に食材管理をしたいユーザー
- 高齢者世帯（買い物の重複を避けたい）

## 3. 機能要件

### 3.1 コア機能

#### ユーザー登録・認証機能
- **ユーザー登録**: メールアドレス、パスワード、表示名
- **ログイン・ログアウト**: セッション管理（ElastiCache Redis）
- **パスワードリセット**: SES経由でのメール送信
- **プロフィール管理**: 表示名、アバター画像（S3保存）

#### ルーム・チーム管理機能
- **ルーム作成**: 冷蔵庫単位でのルーム作成（例：「田中家の冷蔵庫」「シェアハウス1階」）
- **ルーム参加**: 招待コードまたはQRコードでの参加
- **メンバー管理**: ルーム管理者によるメンバーの招待・除外
- **権限管理**: 管理者・一般メンバーの権限設定
- **複数ルーム対応**: 1ユーザーが複数のルームに参加可能

#### 食材登録機能
- **基本情報登録**:
  - 食材名（必須）
  - 食材カテゴリ（肉類、野菜、調味料、冷凍食品など）
  - 賞味期限・消費期限（どちらか選択可能）
  - 登録者（自動設定）
- **詳細情報登録**:
  - 使用者名（特定の人専用の場合）
  - 使用制限タグ（例：「お弁当用」「夕食のメイン」「子供用」「ダイエット中」）
  - 食材の一言メモ（保存場所、調理メモ、注意事項など）
  - 数量・単位
  - 食材画像（S3保存、CloudFront配信）

#### 共有情報管理機能
- **全体共有メモ**: ルーム全体で共有する情報
  - 買い物予定
  - 今日の夕食メニュー
  - 冷蔵庫の掃除予定
  - その他連絡事項
- **メモの履歴管理**: 過去のメモを保存・検索

#### 通知機能
- **賞味期限アラート**: 
  - 期限当日、3日前、1週間前の通知設定
  - ユーザー個別の通知設定
  - 使用制限タグ別の通知
- **リアルタイム通知**（Action Cable + Redis）: 
  - 他メンバーが食材を使用した際の通知
  - 自分専用食材が使用された際の特別通知
  - 新しい食材が追加された際の通知

#### 食材管理機能
- **在庫一覧表示**: 
  - カテゴリ別表示
  - 期限順表示
  - 登録者・使用者別表示
  - 使用制限タグ別表示
- **検索・フィルタ機能**:
  - 食材名検索
  - カテゴリフィルタ
  - 期限範囲フィルタ
  - 使用制限タグフィルタ
- **使用・消費機能**:
  - 数量減少または完全消費
  - 使用者の記録
  - 使用メモ（どう使ったか）

### 3.2 PWA機能

#### モバイル最適化機能
- **オフライン対応**: Service Workerによるキャッシュ戦略
- **ホーム画面追加**: アプリアイコンでの起動
- **プッシュ通知**: Web Push API（ブラウザ通知）
- **カメラアクセス**: バーコード読み取り、写真撮影
- **タッチ操作**: スワイプ、タップに最適化されたUI

## 4. 非機能要件

### 4.1 性能要件
- **レスポンス時間**: 画面表示は3秒以内
- **同期速度**: リアルタイムデータ同期は1秒以内
- **画像アップロード**: S3への画像アップロードは10秒以内
- **Auto Scaling**: EC2インスタンスの自動スケーリング

### 4.2 可用性要件
- **稼働率**: 99.9%以上（Multi-AZ RDS使用）
- **バックアップ**: RDS自動バックアップ（7日間保持）
- **災害復旧**: 別AZでの復旧体制

### 4.3 セキュリティ要件
- **認証**: Devise + セッション管理（Redis）
- **通信暗号化**: HTTPS（ACM証明書）
- **データ暗号化**: RDS暗号化、S3暗号化
- **IAM**: 最小権限の原則でAWSリソースアクセス制御
- **セキュリティグループ**: 必要最小限のポート開放

### 4.4 互換性要件
- **対応ブラウザ**: Chrome, Safari, Firefox, Edge最新版
- **PWA対応**: Service Worker、Web App Manifest
- **レスポンシブデザイン**: スマートフォンファースト

## 5. 技術スタック

### 5.1 アプリケーション
- **フレームワーク**: Ruby on Rails 7.x
- **Webサーバー**: Nginx + Puma
- **認証**: Devise
- **リアルタイム通信**: Action Cable + Redis
- **フロントエンド**: Hotwire (Turbo + Stimulus)
- **スタイリング**: Tailwind CSS
- **PWA**: Service Worker + Web App Manifest

### 5.2 AWS インフラストラクチャ（コスト最適化版）

#### 無料枠フル活用構成
- **EC2**: t2.micro (750時間/月無料)
- **RDS**: t2.micro PostgreSQL (750時間/月無料)
- **S3**: 5GB無料 (画像保存)
- **Route 53**: ホストゾーン ($0.50/月のみ)

#### 代替技術でコスト削減
- **ElastiCache代替**: Redis Gem (EC2内でRedis実行)
- **ALB代替**: Nginx (EC2内でリバースプロキシ)
- **CloudWatch代替**: Rails Logger + ログファイル監視
- **SES代替**: Gmail SMTP (開発時)

#### 段階的拡張計画
```
Phase 1: 完全無料枠 ($1/月)
Phase 2: 無料枠 + 追加ストレージ ($5/月)
Phase 3: 有料インスタンス ($25/月)
```

### 5.3 CI/CD・開発環境
- **バージョン管理**: GitHub
- **CI/CD**: GitHub Actions
- **コンテナ**: Docker (将来のECS移行用)
- **環境管理**: Rails Credentials + AWS Systems Manager Parameter Store

### 5.4 外部API連携
- **商品データベース**: 楽天商品検索API（バーコード用）
- **OCR**: Google Cloud Vision API（将来機能）
- **Web Push**: 各ブラウザのPush Service

## 6. 低コストAWS インフラ設計

### 6.1 最小構成ネットワーク
```
Internet Gateway
    ↓
EC2 t2.micro (Public Subnet)
├─ Nginx (リバースプロキシ)
├─ Rails App
├─ Redis (インメモリ)
└─ PostgreSQL接続
    ↓
RDS t2.micro (Private Subnet)

S3 (画像保存、無料枠5GB)
```

### 6.2 コスト削減データフロー
```
Client (PWA) 
    ↓ HTTPS (Let's Encrypt無料証明書)
EC2 Public IP / Route 53
    ↓
Nginx → Rails (EC2内)
    ├─ RDS PostgreSQL (データ)
    ├─ Redis Gem (セッション)
    └─ S3 (画像、無料枠内)
```

### 6.3 段階的拡張パス
```
Stage 1: EC2 + RDS (無料枠)
Stage 2: + EBS増量 + S3拡張
Stage 3: + ElastiCache + ALB
Stage 4: + Multi-AZ + Auto Scaling
```

## 7. データベース設計

### 主要テーブル

#### users（ユーザー）
- id, email, password_digest, display_name, avatar_url
- created_at, updated_at

#### rooms（ルーム・冷蔵庫）
- id, name, description, invitation_code, qr_code_url
- created_by（作成者のuser_id）
- created_at, updated_at

#### room_members（ルームメンバー）
- id, room_id, user_id, role（admin/member）
- joined_at, created_at, updated_at

#### food_categories（食材カテゴリ）
- id, name, icon, color
- created_at, updated_at

#### food_items（食材）
- id, room_id, name, category_id
- expiration_date, expiration_type（賞味期限/消費期限）
- registered_by（登録者のuser_id）
- assigned_to（使用者のuser_id、NULL可）
- restriction_tags（JSON配列）
- memo（一言メモ）
- quantity, unit
- image_url（S3のURL）
- status（available/used/expired）
- created_at, updated_at

#### room_shared_memos（共有メモ）
- id, room_id, content, posted_by（投稿者のuser_id）
- is_pinned（重要メモのピン留め）
- created_at, updated_at

#### usage_logs（使用履歴）
- id, food_item_id, used_by（使用者のuser_id）
- used_quantity, usage_memo
- used_at, created_at

#### notifications（通知）
- id, user_id, room_id, food_item_id
- notification_type（expiration_alert/usage_notification）
- title, message, is_read
- scheduled_at, created_at

#### restriction_tags（使用制限タグマスタ）
- id, room_id, name, color, description
- created_at, updated_at

## 8. 画面構成

### 8.1 認証系
- ログイン画面
- ユーザー登録画面
- パスワードリセット画面

### 8.2 ルーム管理
- ルーム選択画面（複数ルーム参加時）
- ルーム作成画面
- ルーム参加画面（招待コード入力、QRコード読み取り）
- ルーム設定画面（メンバー管理、ルーム情報編集）

### 8.3 メイン機能（PWA最適化）
- ダッシュボード（在庫概要、共有メモ表示）
- 食材一覧画面（フィルタ・検索機能付き）
- 食材登録画面（カメラ撮影、バーコード読み取り）
- 食材詳細・編集画面
- 共有メモ画面（投稿・編集・履歴表示）
- 通知一覧画面
- 使用履歴画面
- プロフィール設定画面

### 8.4 PWA特別機能
- **オフライン画面**: ネットワーク切断時の表示
- **インストール促進**: ホーム画面追加の案内
- **カメラ画面**: 食材撮影・バーコード読み取り
- **プッシュ通知設定**: 通知の ON/OFF 設定

## 9. 開発フェーズ（コスト重視）

### フェーズ1（MVP: 2-3ヶ月、$1-3/月）
- **最小インフラ**: EC2 t2.micro + RDS t2.micro（無料枠）
- **基本機能**: ユーザー認証、ルーム管理
- **食材管理**: 手動登録、基本CRUD
- **簡易キャッシュ**: Redis Gem（EC2内）
- **SSL**: Let's Encrypt（無料証明書）

### フェーズ2（3-4ヶ月、$5-10/月）
- **ストレージ拡張**: S3追加利用
- **リアルタイム**: Action Cable + Redis
- **画像機能**: S3連携、無料枠内
- **監視**: Rails Logger + ログローテーション
- **バックアップ**: RDS自動バックアップ（無料）

### フェーズ3（4-6ヶ月、$25-35/月）
- **スケールアップ**: t3.micro移行
- **高度機能**: バーコード読み取り
- **CI/CD**: GitHub Actions（無料）
- **監視強化**: 簡易CloudWatch
- **パフォーマンス**: 最適化

## 10. セキュリティ対策

### 10.1 AWS レベル
- **IAM**: 最小権限の原則
- **VPC**: プライベートサブネット配置
- **Security Groups**: 必要最小限のポート開放
- **WAF**: Web Application Firewall（将来）

### 10.2 アプリケーションレベル
- **CSRF対策**: Rails標準機能
- **XSS対策**: HTMLエスケープ
- **SQL Injection対策**: Active Record使用
- **認証**: Devise + 強固なパスワードポリシー

## 11. 監視・運用

### 11.1 監視項目
- **アプリケーション**: レスポンス時間、エラー率
- **インフラ**: CPU使用率、メモリ使用率、ディスク容量
- **データベース**: 接続数、クエリ性能
- **ストレージ**: S3使用量

### 11.2 アラート設定
- **高負荷**: CPU使用率 > 80%
- **エラー**: 5xx エラー > 10回/5分
- **レスポンス**: 平均レスポンス > 3秒
- **データベース**: 接続数 > 80%

## 12. コスト最適化戦略

### 12.1 AWS無料枠活用（12ヶ月間）
- **EC2 t2.micro**: 750時間/月 無料
- **RDS t2.micro**: 750時間/月 無料
- **S3**: 5GB保存 + 20,000 GET + 2,000 PUT 無料
- **CloudFront**: 50GB転送 + 2,000,000リクエスト 無料
- **Route 53**: ホストゾーン1つ（$0.50/月のみ）

### 12.2 最小コスト構成（月額）
- **EC2 t2.micro**: $0（無料枠）
- **RDS t2.micro**: $0（無料枠）
- **S3**: $0-2（無料枠内）
- **Route 53**: $0.50
- **その他**: $0-1
- **合計**: 約$1-3/月

### 12.3 無料枠終了後の低コスト構成（月額）
- **EC2 t3.micro**: $8
- **RDS t3.micro**: $12
- **S3**: $2-5
- **Route 53**: $0.50
- **合計**: 約$22-25/月

### 12.4 コスト削減のための代替案
```yaml
高コスト項目の代替:
  ElastiCache: → Redis on EC2 or インメモリキャッシュ
  ALB ($20/月): → EC2直接アクセス + Nginx
  Multi-AZ RDS: → 単一AZ + 手動バックアップ
  CloudFront: → S3直接配信（無料枠内）
```

## 13. 転職アピールポイント

### 13.1 技術スキル
- **フルスタック開発**: Rails + AWS + PWA
- **インフラ設計**: Multi-AZ, Auto Scaling
- **リアルタイム通信**: WebSocket, Action Cable
- **モバイル対応**: PWA, レスポンシブデザイン
- **CI/CD**: GitHub Actions, 自動デプロイ

### 13.2 運用経験
- **監視・アラート**: CloudWatch設定
- **セキュリティ**: AWS セキュリティベストプラクティス
- **コスト最適化**: リソース使用量監視
- **パフォーマンス**: データベースチューニング

### 13.3 ビジネス理解
- **ユーザー中心設計**: PWAでのUX最適化
- **スケーラビリティ**: 成長に応じたインフラ設計
- **運用性**: 監視・ログによる障害対応
- **コスト意識**: 段階的なインフラ拡張

この要件定義書を基に、実際のAWS環境構築から始めて、段階的にアプリケーションを開発していくことで、転職市場で高く評価される実践的なスキルセットを身につけることができます。