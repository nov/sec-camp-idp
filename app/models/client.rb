class Client < ApplicationRecord
  has_many :authorizations

  validates :identifier,   presence: true, uniqueness: true
  validates :secret,       presence: true
  validates :name,         presence: true
  validates :redirect_uri, presence: true, url: true
  before_validation :setup, on: :create

  def as_json(options = {})
    {
      client_id: identifier,
      client_secret: secret
    }
  end

  private

  def setup
    self.identifier = SecureRandom.hex 16
    self.secret     = SecureRandom.hex 32
  end
end
