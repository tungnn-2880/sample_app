class User < ApplicationRecord
  scope :order_by_name, ->(sort_order){order("LOWER(name) #{sort_order}")}
  VALID_EMAIL_REGEX = /\A[\w\-.+]+@[a-z\-\d.]+\.[a-z]+\z/i.freeze
  before_save{email.downcase!}
  before_create :create_activation_digest
  validates :name, presence: true,
            length: {maximum: Settings.max_length.name_50}
  validates :email, presence: true,
            length: {maximum: Settings.max_length.email_255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
            length: {minimum: Settings.max_length.password_8},
            allow_nil: true
  has_secure_password
  attr_accessor :remember_token, :activation_token

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end
  end

  def remember_me
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    BCrypt::Password.new(digest).is_password? token
  end

  def is_only_password_invalid?
    valid?
    errors.attribute_names == [:password]
  end

  def activated?
    activated_at.present?
  end
  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
