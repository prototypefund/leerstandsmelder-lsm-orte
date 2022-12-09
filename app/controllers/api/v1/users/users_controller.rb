# frozen_string_literal: true

class Api::V1::Users::UsersController < Api::V1::ApplicationController
  include Paginable

  before_action :set_user, only: %i[show edit update destroy]

  def create
    authorize User
    @user = User.new(user_params)
    password_length = 10
    password = Devise.friendly_token.first(password_length)
    @user.password = password
    @user.password_confirmation = password

    respond_to do |format|
      if @user.save
        ApplicationMailer.notify_user_created(@user).deliver_now
        ApplicationMailer.notify_admin_user_created(@user, admin_adresses).deliver_now
        format.json { render :show, status: :created, location: @user }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize User
    @user.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def edit; end

  def index
    authorize User
    sortable_params = params[:sort].present? ? "#{params[:sort]} #{sort_direction}" : 'created_at desc'
    @users = if params[:query].present?
               User.where('lower(nickname) LIKE :search OR lower(email) LIKE :search', search: "%#{params[:query].downcase}%").reorder(Arel.sql(sortable_params))
             else
               User.reorder(Arel.sql(sortable_params))
             end
    paginated = paginate(@users)
    @users.present? ? render_collection(paginated) : :not_found
  end

  def new
    authorize User
    @user = User.new
    @groups = if current_user&.admin? && current_user.group.title == 'Admins'
                Group.all
              else
                Group.by_user(current_user)
              end
  end

  def show
    respond_to do |format|
      format.json { render json: UserSerializer.new(@user, { params: { admin: current_user.admin?, current_user: current_user } }).serializable_hash, status: :ok }
    end
  end

  def update
    sanitized_params = user_params
    sanitized_params.delete(:password) if sanitized_params[:password].blank?

    respond_to do |format|
      if @user.update(sanitized_params)
        format.json { render json: UserSerializer.new(current_user, { params: { admin: current_user.admin?, current_user: current_user } }).serializable_hash, status: :ok }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def update_resource(resource, account_update_params)
    resource.update_without_password(account_update_params)
  end

  private

  def admin_adresses
    User.where(role: :admin).joins(:group).where("groups.title = 'Admins'").collect(&:email)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    authorize User
    @user = User.find(params[:id])
    @groups = if current_user.admin?
                Group.all
              else
                Group.by_user(current_user)
              end
    authorize @user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    permitted_attributes = [:email, :nickname, :message_me, :notify, :share_email, :accept_terms, :password, :group_id, { role_ids: [] }]
    # permitted_attributes << :role if current_user.try(:admin?)
    params.require(:user).permit(permitted_attributes)
  end

  def serializer
    UserSerializer
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_dir]) ? params[:sort_dir] : 'asc'
  end
end
