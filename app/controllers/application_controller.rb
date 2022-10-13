# frozen_string_literal: true

class ApplicationController < ActionController::Base
  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!

  protect_from_forgery with: :exception

  def report_csp
    # do nothing right now...
  end

  def default_checkbox(param)
    if %w[on true].include?(param)
      true
    else
      false
    end
  end
end
