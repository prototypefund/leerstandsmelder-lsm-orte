# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ApplicationController
      skip_before_action :verify_authenticity_token
      include DeviseTokenAuth::Concerns::SetUserByToken

      protect_from_forgery with: :null_session
      respond_to :json
    end
  end
end
