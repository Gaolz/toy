class User < ApplicationRecord

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  has_many :microposts, dependent: :destroy

  validates :name,  presence: true, length: { maximum: 50 },   on: :create
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },\
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false },  on: :create

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 为了持久保存会话，在数据库中记住用户
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 如果指定的令牌和摘要匹配，返回 true
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token 
  end

  # 忘记用户
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 返回指定字符串的哈希摘要
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 返回一个随机令牌
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 激活账户
  def activate
    update_columns(activated: true, activated_at: Time.current)
  end

  # 发送激活邮件
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # 设置密码重设相关的属性
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(:reset_digest => User.digest(reset_token), :reset_send_at => Time.current)
  end

  # 发送密码重设邮件
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # 如果密码重设请求超时了，返回 true
  def password_reset_expired?
    reset_send_at < 2.hours.ago
  end

  # 实现动态流原型
  def feed
    Micropost.where("user_id = ?", id)
  end

  private
    
    # 电子邮件小写化
    def downcase_email
      self.email = email.downcase
    end

    # 创建并赋值激活令牌和摘要
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
