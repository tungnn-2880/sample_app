class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w\-.+]+@[a-z\-\d.]+\.[a-z]+\z/i.freeze
  before_save{email.downcase!}
  validates :name, presence: true,
            length: {maximum: Settings.max_length.name_50}
  validates :email, presence: true,
            length: {maximum: Settings.max_length.email_255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
            length: {minimum: Settings.max_length.password_8}
  has_secure_password
end
