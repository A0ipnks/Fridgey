#!/usr/bin/env ruby
# パスワード管理スクリプト

puts "🔐 フリジルアプリ - パスワード管理"
puts "=" * 50

# 引数チェック
if ARGV.empty?
  puts <<~USAGE
    使用方法:
      rails runner scripts/password_management.rb <コマンド> [email] [password]

    コマンド:
      check <email>              - パスワード認証テスト
      reset <email> <new_pass>   - パスワードリセット（管理者用）
      info <email>               - パスワード関連情報表示
      list                       - 全ユーザーのパスワード情報

    例:
      rails runner scripts/password_management.rb check test@example.com
      rails runner scripts/password_management.rb reset test@example.com newpass123
  USAGE
  exit
end

command = ARGV[0]
email = ARGV[1]
password = ARGV[2]

case command
when 'list'
  puts "📊 全ユーザーのパスワード情報:"
  puts "-" * 30

  User.all.each do |user|
    puts "Email: #{user.email}"
    puts "  ID: #{user.id}"
    puts "  暗号化パスワード: #{user.encrypted_password[0..15]}..."
    puts "  更新日時: #{user.updated_at.strftime('%Y/%m/%d %H:%M')}"
    puts
  end

when 'info'
  if email.nil?
    puts "❌ エラー: メールアドレスを指定してください"
    exit 1
  end

  user = User.find_by(email: email)
  if user.nil?
    puts "❌ エラー: ユーザーが見つかりません (#{email})"
    exit 1
  end

  puts "👤 ユーザー情報: #{user.email}"
  puts "  表示名: #{user.display_name || '（未設定）'}"
  puts "  ID: #{user.id}"
  puts "  🔐 暗号化パスワード: #{user.encrypted_password}"
  puts "  📅 作成日時: #{user.created_at.strftime('%Y/%m/%d %H:%M')}"
  puts "  📅 更新日時: #{user.updated_at.strftime('%Y/%m/%d %H:%M')}"

when 'check'
  if email.nil?
    puts "❌ エラー: メールアドレスを指定してください"
    exit 1
  end

  user = User.find_by(email: email)
  if user.nil?
    puts "❌ エラー: ユーザーが見つかりません (#{email})"
    exit 1
  end

  print "パスワードを入力してください: "
  input_password = gets.chomp

  if user.valid_password?(input_password)
    puts "✅ 認証成功: パスワードが正しいです"
  else
    puts "❌ 認証失敗: パスワードが間違っています"
  end

when 'reset'
  if email.nil? || password.nil?
    puts "❌ エラー: メールアドレスと新しいパスワードを指定してください"
    exit 1
  end

  user = User.find_by(email: email)
  if user.nil?
    puts "❌ エラー: ユーザーが見つかりません (#{email})"
    exit 1
  end

  puts "⚠️  警告: #{user.email} のパスワードを変更します"
  print "続行しますか？ (y/N): "
  confirmation = gets.chomp.downcase

  if confirmation == 'y' || confirmation == 'yes'
    user.password = password
    user.password_confirmation = password

    if user.save
      puts "✅ パスワード変更成功"
      puts "🔐 新しい暗号化パスワード: #{user.encrypted_password[0..20]}..."
    else
      puts "❌ パスワード変更失敗: #{user.errors.full_messages.join(', ')}"
    end
  else
    puts "⭕ キャンセルされました"
  end

else
  puts "❌ エラー: 不明なコマンド '#{command}'"
  puts "使用可能なコマンド: list, info, check, reset"
end