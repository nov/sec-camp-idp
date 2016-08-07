class AuthorizationsController < ApplicationController
  include Concerns::ConnectEndpoint

  before_action :require_oauth_request
  before_action :require_client
  before_action :require_connect_context_for_id_token_response_types
  before_action :require_authentication
  before_action :restrict_max_age, only: :new

  def new
  end

  def create
    if params[:commit] == 'approve'
      authorization = current_account.authorizations.create(
        client: @client,
        nonce: oauth_request.nonce
      )
      authorization.scopes << requested_scopes
      response_types = Array(oauth_request.response_type)
      if response_types.include? :code
        oauth_response.code = @code = authorization.code
      end
      if response_types.include? :token
        oauth_response.access_token = @access_token = authorization.access_token(:via_implicit).to_bearer_token
      end
      if response_types.include? :id_token
        oauth_response.id_token = authorization.id_token.to_jwt do |id_token|
          id_token.code = @code
          id_token.access_token = @access_token
        end
      end
      oauth_response.redirect_uri = @redirect_uri
      oauth_response.approve!
      redirect_to oauth_response.location
    else
      oauth_request.access_denied!
    end
  end

  private

  def require_client
    logger.info "require_client: #{oauth_request.client_id}"
    @client = Client.find_by(identifier: oauth_request.client_id) or oauth_request.invalid_request!
    logger.info "require_client: #{@client}"
    @redirect_uri = oauth_request.verify_redirect_uri! @client.redirect_uri
  end

  def require_connect_context_for_id_token_response_types
    if Array(oauth_request.response_type).include?(:id_token) && !requested_scopes.include?(Scope::OPENID)
      oauth_request.unsupported_response_type!
    end
  end

  def requested_scopes
    @requested_scopes ||= Scope.where(name: oauth_request.scope.split)
  end
  helper_method :requested_scopes

  def restrict_max_age
    acceptable_clock_skew = 3.seconds
    if (
      oauth_request.prompt == 'login' && !current_account.logged_in_within?(acceptable_clock_skew) ||
      oauth_request.max_age.present?  && !current_account.logged_in_within?(acceptable_clock_skew + oauth_request.max_age.seconds)
    )
      unauthenticate!
      require_authentication
    end
  end
end
