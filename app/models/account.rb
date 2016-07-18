class Account < ApplicationRecord
  has_many :authorizations

  validates :identifier, presence: true, uniqueness: true
  validates :email,      presence: true, uniqueness: true, email: true
  validates :name,       presence: true
  before_validation :setup, on: :create

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
      userinfo.email_verified = false
    end
    if access_token.scopes.include? Scope::ADDRESS
      userinfo.address = {
        formatted: 'Shibuya, Tokyo, Japan'
      }
    end
    if access_token.scopes.include? Scope::PHONE
      userinfo.phone_number = '+81 (3) 1234 5678'
      userinfo.phone_number_verified = false
    end
    userinfo
  end

  private

  def setup
    self.identifier = SecureRandom.hex 16
  end

  class << self
    def authenticate!(params = {})
      account = find_or_initialize_by(email: params[:email])
      account.name ||= params[:name]
      account.save!
      account
    end
  end
end
