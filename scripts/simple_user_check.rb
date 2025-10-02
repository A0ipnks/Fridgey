#!/usr/bin/env ruby
# シンプルなユーザー確認スクリプト

puts "🧊 フリッジーアプリ - ユーザー情報"
puts "=" * 40

total = User.count
puts "📊 総ユーザー数: #{total}人"

if total > 0
  puts "\n👥 ユーザー一覧:"
  User.all.each_with_index do |user, i|
    puts "#{i+1}. #{user.display_name || user.email}"
    puts "   Email: #{user.email}"
    puts "   ID: #{user.id}"
    puts "   登録: #{user.created_at.strftime('%Y/%m/%d %H:%M')}"
    puts
  end
else
  puts "😔 ユーザーが登録されていません"
end
