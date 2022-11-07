# frozen_string_literal: true

class Api::V1::Users::ConfirmationsController < DeviseTokenAuth::ConfirmationsController
  before_action :authenticate_user!, except: %i[new create show]
end
