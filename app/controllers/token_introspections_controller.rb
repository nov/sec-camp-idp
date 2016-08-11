class TokenIntrospectionsController < ApplicationController
  before_action :require_access_token

  def show
    render json: {
      iss: Rails.application.secrets.issuer,
      aud: current_token.authorization.client.identifier,
      sub: current_token.authorization.account.identifier,
      scopes: current_token.scopes.collect(&:name),
      iat: current_token.created_at.to_i,
      exp: current_token.expires_at.to_i
    }
  end
end
