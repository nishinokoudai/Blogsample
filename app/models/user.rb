class User < ActiveRecord::Base
    attr_accessor :remember_token
    before_save { self.email = email.downcase }
    validates :name,  presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    
    # 与えられた文字列のハッシュ値を返す
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    # ランダムなトークンを返す
    def User.new_token
        SecureRandom.urlsafe_base64
    end
    
    # 永続的セッションで使用するユーザーをデータベースに記憶する
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    # 渡されたトークンがダイジェストと一致したらtrueを返す
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    
    # ユーザーログインを破棄する
    def forget
        update_attribute(:remember_digest, nil)
    end
    
    # CSVファイルの内容をDBに登録する
    def self.import(file)
    
    imported_num = 0
    
    # 文字コード変換のためにKernel#openとCSV#newを併用。
    open(file.path, 'r:cp932:utf-8', undef: :replace) do |f|
    csv = CSV.new(f, :headers => :first_row)
    csv.each do |row|
    next if row.header_row?
    
    # CSVの行情報をHASHに変換
    table = Hash[[row.headers, row.fields].transpose]
    
    # 登録済みユーザー情報取得。
    # 登録されてなければ作成
    user = find_by(:id => table["id"])
    if user.nil?
    user = new
    end

    # ユーザー情報更新
    user.attributes = table.to_hash.slice(
                                          *table.to_hash.except(:id, :created_at, :updated_at).keys)

    # バリデーションOKの場合は保存
    if user.valid?
        user.save!
        imported_num += 1
    end
    end
    end

    # 更新件数を返却
    imported_num

    end
end