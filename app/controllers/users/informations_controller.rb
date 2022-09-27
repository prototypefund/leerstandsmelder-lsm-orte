class Users::InformationsController < ApplicationController
  #before_action :authorize_access_request!
  before_action :authenticate_user!

  def me
    render json: current_user.as_json(only: [:id, :email]), status: :ok
  end
end