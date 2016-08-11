class SigningKey < ApplicationRecord
  scope :active, -> { where(active: true) }

  def private_key
    OpenSSL::PKey::RSA.new pem
  end

  def public_key
    private_key.public_key
  end

  def private_jwk
    JSON::JWK.new private_key
  end

  def public_jwk
    JSON::JWK.new public_key
  end

  def deactivate!
    self.active = false
    save!
  end

  class << self
    def current
      active.last
    end

    def rotate!
      create!(
        pem: OpenSSL::PKey::RSA.generate(2048).to_pem
      )
    end

    def jwk_set
      JSON::JWK::Set.new active.collect(&:public_jwk)
    end
  end
end
