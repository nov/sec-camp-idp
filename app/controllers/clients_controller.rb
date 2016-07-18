class ClientsController < ApplicationController
  def create
    client = Clients.new params[:client]
    if client.save
      render json: client
    else
      render json: {
        error: :invalid_client_metadata
      }, status: 400
    end
  end
end
