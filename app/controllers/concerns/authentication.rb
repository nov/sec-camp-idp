module Concerns
  module Authentication
    class AuthenticationRequired < StandardError; end
    class AnonymousAccessRequired < StandardError; end

    def self.included(klass)
      klass.send :helper_method, :current_account, :authenticated?
      klass.send :before_filter, :optional_authentication
      klass.send :rescue_from, AuthenticationRequired,  with: :authentication_required!
      klass.send :rescue_from, AnonymousAccessRequired, with: :anonymous_access_required!
    end

    def authenticated?
      !current_account.blank?
    end

    def current_account
      @current_account
    end

    def current_token
      @current_token ||= request.env[Rack::OAuth2::Server::Resource::ACCESS_TOKEN]
    end

    def authentication_required!(e)
      redirect_to new_session_url
    end

    def anonymous_access_required!(e)
      redirect_to session_url
    end

    def optional_authentication
      if session[:current_account]
        authenticate Account.find_by_id(session[:current_account])
      end
    rescue ActiveRecord::RecordNotFound
      unauthenticate!
    end

    def require_authentication
      unless authenticated?
        session[:after_logged_in_endpoint] = request.url if request.get?
        raise AuthenticationRequired.new
      end
    end

    def require_anonymous_access
      raise AnonymousAccessRequired.new if authenticated?
    end

    def optional_authentication
      if session[:current_account]
        authenticate Account.find_by_id(session[:current_account])
      end
    rescue ActiveRecord::RecordNotFound
      unauthenticate!
    end

    def require_access_token
      unless current_token
        raise Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new
      end
    end

    def authenticate(account)
      if account
        @current_account = account
        session[:current_account] = account.id
      end
    end

    def unauthenticate!
      @current_account = session[:current_account] = nil
    end

    def logged_in!
      current_account.update_attributes(last_logged_in_at: Time.now.utc)
      redirect_to after_logged_in_endpoint
    end

    def after_logged_in_endpoint
      session.delete(:after_logged_in_endpoint) || session_url
    end
  end
end