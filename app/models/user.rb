# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user if user.try(:is_password?, password)
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  validates :password_digest, :session_token, :username, presence: true
  validates :session_token, :username, uniqueness: true
  validates :password, length: { minimum: 8, allow_nil: true }

  after_initialize :ensure_session_token

  attr_reader :password

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    save
    session_token
  end
end
