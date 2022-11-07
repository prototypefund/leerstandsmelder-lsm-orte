# frozen_string_literal: true


  class Api::V1::Users::PasswordsController < DeviseTokenAuth::PasswordsController
    before_action :validate_redirect_url_param, only: [:create, :edit]
    before_action :authenticate_user!, except: %i[new create update]
    skip_after_action :update_auth_header, only: [:create, :edit]
  end