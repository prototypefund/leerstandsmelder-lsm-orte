# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protect_from_forgery with: :exception

  def after_sign_out_path_for(resource_or_scope)
    # logic here
    puts 'logged out'
  end

  protected

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

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end
end
