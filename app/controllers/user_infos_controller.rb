class UserInfosController < ApplicationController
  before_action :require_access_token

  def show
    userinfo = if current_token.scopes.include? Scope::OPENID
      current_token.account.to_response_object(current_token)
    else
      current_token.account.as_json
    end
    render json: userinfo
  end
end
