# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: %i[new create]

  protect_from_forgery unless: -> { request.format.json? }

  before_action :cors_set_access_control_headers

  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = 'http://localhost:8080'
    headers['Access-Control-Allow-Methods'] = '*'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Credentials'] = true
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization, access-token, expiry, token-type, uid, client'
    headers['Access-Control-Expose-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization, access-token, expiry, token-type, uid, client'
  end

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
