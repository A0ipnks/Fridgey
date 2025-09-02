#!/usr/bin/env ruby
# ユーザー情報確認スクリプト

puts "🧊 フリジルアプリ - ユーザー情報確認"
puts "=" * 50

# 総数確認
total_users = User.count
puts "📊 総ユーザー数: #{total_users}人"

if total_users == 0
  puts "😔 まだユーザーが登録されていません"
  puts "💡 ブラウザで http://localhost:3000/users/sign_up からユーザー登録してください"
else
  puts "\n👥 登録済みユーザー一覧:"
  puts "-" * 30

  User.all.each_with_index do |user, index|
    puts "#{index + 1}. #{user.display_name || user.email}"
    puts "   📧 Email: #{user.email}"
    puts "   🆔 ID: #{user.id}"
    puts "   📅 登録日: #{user.created_at.strftime('%Y/%m/%d %H:%M')}"

    # 関連データの確認
    room_count = user.rooms.count
    created_room_count = user.created_rooms.count

    puts "   🏠 参加ルーム数: #{room_count}個"
    puts "   🏗️  作成ルーム数: #{created_room_count}個"
    puts
  end

  # 最新のユーザー情報
  latest_user = User.last
  puts "🆕 最新登録ユーザー: #{latest_user.display_name || latest_user.email}"
  puts "   登録: #{latest_user.created_at.strftime('%Y年%m月%d日 %H:%M')}"
end

puts "\n🔧 その他の確認コマンド:"
puts "User.count                     # 総数"
puts "User.all                       # 全一覧"
puts "User.find(1)                   # ID指定"
puts "User.find_by(email: 'xxx')     # Email検索"
puts "Room.count                     # ルーム総数"
puts "RoomMember.count               # 参加関係総数"