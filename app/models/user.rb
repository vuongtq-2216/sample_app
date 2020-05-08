class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  ATTR_PARAMS = %i(name email password password_confirmation).freeze
  before_save{email.downcase!}
  validates :name, presence: true, length: {maximum: Settings.max_length_name}
  validates :email, presence: true,
                    length: {maximum: Settings.max_length_email},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  has_secure_password
  validates :password, presence: true,
            length: {minimum: Settings.min_length_pwd}
end
