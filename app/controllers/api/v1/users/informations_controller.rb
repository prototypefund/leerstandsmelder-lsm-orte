# frozen_string_literal: true

class Api::V1::Users::InformationsController < Api::V1::ApplicationController
  # before_action :authorize_access_request!
  before_action :authenticate_user!

  def me
    # render json: current_user.to_json(only: %i[id email roles]), status: :ok
    render json: UserSerializer.new(current_user, { params: { current_user: current_user } }).serializable_hash, status: :ok
  end
end
