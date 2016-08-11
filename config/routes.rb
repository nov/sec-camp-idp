Rails.application.routes.draw do
  resources :authorizations, only: [:new, :create]
  resources :clients, only: :create
  resource :user_info, only: :show
  resource :session, only: [:show, :new, :create, :destroy]
  resource :token_introspection, only: :show

  get '.well-known/:id', to: 'discovery#show'
  post 'tokens', to: proc { |env| TokenEndpoint.new.call(env) }
  get 'jwks.json', as: :jwks, to: proc { |env|
    [200, {'Content-Type' => 'application/json'}, [SigningKey.jwk_set.to_json]]
  }

  root to: 'sessions#show'
end
