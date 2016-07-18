class Client < ApplicationRecord
  serialize :redirect_uris, JSON
  has_many :authorizations

  validates :identifier,    presence: true, uniqueness: true
  validates :secret,        presence: true
  validates :redirect_uris, presence: true
  before_validation :setup, on: :create

  private

  def setup
    self.identifier = SecureRandom.hex 16
    self.secret     = SecureRandom.hex 32
  end
end
