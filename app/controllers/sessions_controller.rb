class SessionsController < ApplicationController
  before_action :require_authentication, only: [:show, :destroy]
  before_action :require_anonymous_access, only: [:new, :create]

  def show
  end

  def new
  end

  def create
    account = Account.authenticate!(params)
    authenticate account
    logged_in!
  rescue => e
    redirect_to new_session_url, flash: {
      error: e.message
    }
  end

  def destroy
    unauthenticate!
    redirect_to new_session_url
  end
end
