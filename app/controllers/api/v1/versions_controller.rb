# frozen_string_literal: true

class Api::V1::VersionsController < Api::V1::ApplicationController
  before_action :authenticate_user!
  before_action :set_version, only: %i[show]

  # GET /versions.json
  def index
    # @versions = policy_scope(PaperTrail::Version).order(:created_at => :desc).limit(20)
    @versions = policy_scope(PaperTrail::Version, policy_scope_class: VersionPolicy::Scope).where('whodunnit IS NOT ?', nil).order(created_at: :desc).limit(20)
    user_ids = @versions.collect(&:whodunnit).reject(&:blank?).map(&:to_i).uniq
    @version_users = User.where(id: user_ids)
    # policy_scope(Version).order(:created_at)
    # authorize @versions
    respond_to do |format|
      if @versions
        format.json { render :index }
      else
        format.json { head :no_content }
      end
    end
  end

  # GET /versions
  def user_versions
    if params[:user_id]
      @user = User.find(params[:user_id])
      @versions = policy_scope(PaperTrail::Version, policy_scope_class: VersionPolicy::Scope).where(whodunnit: @user).order(created_at: :desc).limit(20).includes(:item)
    end
    # authorize @versions
    respond_to do |format|
      if @versions
        format.json { render :index }
      else
        format.json { head :no_content }
      end
    end
  end

  # GET /versions/1.json
  def show
    respond_to do |format|
      if @version
        format.json { render :show }
      else
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_version
    @version = PaperTrail::Version.find(params[:id])
    authorize @version, policy_class: VersionPolicy
  end
end
