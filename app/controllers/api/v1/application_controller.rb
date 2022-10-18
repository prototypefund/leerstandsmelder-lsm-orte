class Api::V1::ApplicationController < ActionController::API
  include ActionController::MimeResponds
  
  acts_as_token_authentication_handler_for User


  protect_from_forgery with: :null_session, if: :json_request?


  after_filter :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  protected

  def json_request?
    request.format.json?
  end
  
end
