# frozen_string_literal: true

class Api::V1::ApplicationController < ::ApplicationController
  skip_before_action :verify_authenticity_token
  include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery with: :null_session
  respond_to :json
end
 