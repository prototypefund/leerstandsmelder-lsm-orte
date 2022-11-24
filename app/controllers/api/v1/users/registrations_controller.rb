# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :set_user_by_token, only: %i[destroy update]
  before_action :validate_sign_up_params, only: :create
  before_action :validate_account_update_params, only: :update
  skip_after_action :update_auth_header, only: %i[create destroy]

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[user registration nickname email accept_terms password password_confirmation])
  end
end
