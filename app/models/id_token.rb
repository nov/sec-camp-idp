class IdToken < ApplicationRecord
  belongs_to :authorization

  before_validation :setup, on: :create

  delegate :account, :client, to: :authorization

  def to_response_object(&block)
    response_object = OpenIDConnect::ResponseObject::IdToken.new(
      iss: Rails.application.secrets.issuer,
      sub: account.identifier,
      aud: client.identifier,
      nonce: nonce,
      exp: expires_at.to_i,
      iat: created_at.to_i,
      auth_time: account.last_logged_in_at.to_i
    )
    yield response_object
    response_object
  end

  def to_jwt(&block)
    to_response_object(&block).to_jwt(SigningKey.current.private_jwk)
  end

  private

  def setup
    self.expires_at = 1.hours.from_now
  end
end
