# frozen_string_literal: true

class Api::V1::ApplicationController < ::ApplicationController
  skip_before_action :verify_authenticity_token
  include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery with: :null_session
  respond_to :json

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized(exception)
    # puts 'json: user not authorized'
    policy_name = exception.policy.class.to_s.underscore
    respond_to do |format|
      format.json do
        self.status = :unauthorized
        self.response_body = { error: "Access denied: #{policy_name}.#{exception.query}" }.to_json
      end
    end
  end
end
