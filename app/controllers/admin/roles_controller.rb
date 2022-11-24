# frozen_string_literal: true

class Admin::RolesController < ApplicationController
  before_action :set_admin_role, only: %i[edit update destroy]

  def index
    @admin_roles = if current_user.admin?
                     Role.all
                   else
                     Role.by_user(current_user)
                   end
    authorize Role
  end

  def new
    authorize Role
    @admin_role = Role.new
  end

  def edit
    redirect_to admin_roles_path, notice: "You can't edit this role." unless @admin_role
  end

  def create
    authorize Role
    @admin_role = Role.new(admin_role_params)

    respond_to do |format|
      if @admin_role.save
        format.html { redirect_to admin_roles_url, notice: 'Role was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @admin_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin_roles/1
  # PATCH/PUT /admin_roles/1.json
  def update
    respond_to do |format|
      if @admin_role.update(admin_role_params)
        format.html { redirect_to admin_roles_url, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_role }
      else
        format.html { render :edit }
        format.json { render json: @admin_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_roles/1
  # DELETE /admin_roles/1.json
  def destroy
    authorize Role
    @admin_role.destroy
    respond_to do |format|
      format.html { redirect_to admin_roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_role
    @admin_role = if current_user.admin?
                    Role.find_by_id(params[:id])
                  else
                    [] # Role.by_user(current_user).find_by_id(params[:id])
                  end
    authorize @admin_role
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_role_params
    params.require(:admin_role).permit(:name)
  end
end
