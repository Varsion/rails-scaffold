class User < ApplicationRecord
  validates :email, uniqueness: true
  has_secure_password

  def login
    JWT.encode({
      user_id: id,
      created_at: DateTime.now.strftime("%Q")
    }, Rails.application.credentials.secret_key_base)
  end
end
