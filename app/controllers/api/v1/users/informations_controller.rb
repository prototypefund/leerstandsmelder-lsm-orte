# frozen_string_literal: true

class Api::V1::Users::InformationsController < Api::V1::ApplicationController
  # before_action :authorize_access_request!
  before_action :authenticate_user!

  def me
    render json: current_user.as_json(only: %i[id email role]), status: :ok
  end
end
