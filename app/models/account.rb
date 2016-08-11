class Account < ApplicationRecord
  has_secure_password

  has_many :authorizations

  validates :identifier, presence: true, uniqueness: true
  validates :email,      presence: true, uniqueness: true, email: true
  validates :name,       presence: true
  before_validation :setup, on: :create

  def logged_in_within?(max_age)
    last_logged_in_at > max_age.ago
  end

  def to_response_object(access_token)
    userinfo = OpenIDConnect::ResponseObject::UserInfo.new
    if access_token.scopes.include? Scope::OPENID
      userinfo.subject = identifier
    end
    if access_token.scopes.include? Scope::PROFILE
      userinfo.name = name
    end
    if access_token.scopes.include? Scope::EMAIL
      userinfo.email = email
      userinfo.email_verified = true
    end
    if access_token.scopes.include? Scope::ADDRESS
      userinfo.address = {
        formatted: address
      }
    end
    if access_token.scopes.include? Scope::PHONE
      userinfo.phone_number = phone
      userinfo.phone_number_verified = false
    end
    userinfo
  end

  def as_json(options = {})
    scopes = Array(options[:scopes])
    userinfo = {
      id: identifier,
      name: name
    }
    userinfo.merge! email: email if scopes.include? Scope::EMAIL
    userinfo.merge! phone: phone if scopes.include? Scope::ADDRESS
    userinfo.merge! address: address if scopes.include? Scope::ADDRESS
    userinfo
  end

  private

  def setup
    self.identifier = SecureRandom.hex 16
  end

  class << self
    def authenticate!(params = {})
      account = find_or_initialize_by(email: params[:email])
      account.authenticate params[:password] or raise 'Authentication Failed'
    end
  end
end
