# frozen_string_literal: true

class Admin::GroupsController < ApplicationController
  before_action :set_admin_group, only: %i[edit update destroy]

  def index
    @admin_groups = if current_user.admin? && current_user.group.title == 'Admins'
                      Group.all
                    else
                      Group.by_user(current_user)
                    end
  end

  def new
    @admin_group = Group.new
  end

  def edit
    redirect_to admin_groups_path, notice: "You can't edit this group." unless @admin_group
  end

  def create
    @admin_group = Group.new(admin_group_params)

    respond_to do |format|
      if @admin_group.save
        format.html { redirect_to admin_groups_url, notice: 'Group was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @admin_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin_groups/1
  # PATCH/PUT /admin_groups/1.json
  def update
    respond_to do |format|
      if @admin_group.update(admin_group_params)
        format.html { redirect_to admin_groups_url, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_group }
      else
        format.html { render :edit }
        format.json { render json: @admin_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_groups/1
  # DELETE /admin_groups/1.json
  def destroy
    @admin_group.destroy
    respond_to do |format|
      format.html { redirect_to admin_groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_group
    @admin_group = if current_user.admin?
                     Group.find_by_id(params[:id])
                   else
                     Group.by_user(current_user).find_by_id(params[:id])
                   end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_group_params
    params.require(:admin_group).permit(:title, :active, :message)
  end
end
