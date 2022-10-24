# frozen_string_literal: true

class StartController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index info]

  def index
    authorize :start, :index?
    redirect_to maps_path if current_user
  end

  def info; end

  def notfound; end

  def settings
    authorize :start, :settings?
    @user = current_user
    @users = User.by_group(current_user).order(:email)
    @maps = Map.by_user(current_user).order(:title)
    @groups = if current_user.admin? && current_user.group.title == 'Admins'
                Group.all
              else
                Group.by_user(current_user)
              end
    @roles = if current_user.admin?
               Role.all
             else
               []
             end
  end

  def edit_profile
    authorize :start, :edit_profile?
    @user = current_user
  end

  def update_profile
    @user = current_user
    sanitized_params = params.require(:user).permit(:email, :password, :id)
    sanitized_params.delete(:password) if sanitized_params[:password].blank?

    if current_user.update(sanitized_params)
      redirect_to root_path, notice: 'Your profile was successfully updated.'
    else
      render :edit_profile, notice: 'Your profile could not be updated.'
    end
  end
end
