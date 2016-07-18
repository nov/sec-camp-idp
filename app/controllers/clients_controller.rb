class ClientsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    client = Client.new(
      name: params[:client_name],
      redirect_uri: params[:redirect_uris].try(:first)
    )
    if client.save
      render json: client
    else
      render json: {
        error: :invalid_client_metadata
      }, status: 400
    end
  end
end
