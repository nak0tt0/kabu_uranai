# テスト用ユーザーアカウントの作成

User.find_or_create_by!(email: 'test@example.com') do |user|
  user.name = 'テストユーザー'
  user.password = 'password123'
  user.password_confirmation = 'password123'
end

# テスト用管理者アカウントの作成

Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.name = "管理者"
  admin.password = "password123"
  admin.password_confirmation = "password123"
end

puts "管理者アカウント (admin@example.com) の作成/確認が完了しました。"
