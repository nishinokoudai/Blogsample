require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(Username Email 登録日時)
  csv << csv_column_names
  @users.each do |user|
    csv_column_values = [
      user.name,
      user.email,
      user.created_at.strftime("%Y年%m月%d日 %H時%M分")
    ]
    csv << csv_column_values
  end
end