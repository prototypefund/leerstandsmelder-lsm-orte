# frozen_string_literal: true

class Api::V1::ApplicationController < ::ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_admin
  include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery with: :null_session
  respond_to :json

  rescue_from StandardError, with: :internal_server_error
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

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

  def not_found(exception)
    if Rails.env.development?
      render json: { error: exception.message }, status: :not_found
    else
      render json: { error: 'record not found' }, status: :not_found
    end
  end

  def internal_server_error(exception)
    response = if Rails.env.development?
                 { type: exception.class.to_s, message: exception.message, backtrace: exception.backtrace }
               else
                 { error: 'Internal Server Error' }
               end
    render json: response, status: :internal_server_error
  end
end
