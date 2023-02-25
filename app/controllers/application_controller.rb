# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # after_action :verify_authorized, unless: :devise_controller?

  before_action :authenticate_user!, except: %i[new create]
  before_action :require_admin, except: %i[new create]

  protect_from_forgery unless: -> { request.format.json? }

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :cors_set_access_control_headers

  around_action :switch_locale

  before_action :set_paper_trail_whodunnit

  def require_admin
    return if current_user&.admin?

    sign_out
    flash[:error] = 'You are not an admin'
    redirect_to new_user_session_path
  end
  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = ENV.fetch('API_FRONTEND_ALLOW_ORIGIN')

    headers['Access-Control-Allow-Origin'] = 'https://leerstandsmelder.in' if request.origin == 'https://leerstandsmelder.in'
    headers['Access-Control-Allow-Origin'] = 'https://dev.leerstandsmeldung.de' if request.origin == 'https://dev.leerstandsmeldung.de'
    headers['Access-Control-Allow-Origin'] = 'https://leerstandsmelder.de' if request.origin == 'https://leerstandsmelder.de'

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
    if %w[on true].include?(param.to_s)
      true
    else
      false
    end
  end

  def switch_locale(&action)
    locale = extract_locale || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def default_url_options(_options = {})
    # logger.debug "default_url_options is passed options: #{options.inspect}\n"
    # { locale: I18n.locale }
    {}
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:notice] = "#{policy_name}.#{exception.query}"
    redirect_to(request.referrer || root_path)
  end
end
