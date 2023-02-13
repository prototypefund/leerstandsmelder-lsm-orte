# frozen_string_literal: true

class Api::V1::StatusController < Api::V1::ApplicationController
  before_action :switch_config_locale

  def switch_config_locale
    locale = extract_locale || Mobility.locale
    Mobility.locale = locale
    @locale_mobility = locale
  end

  def extract_locale
    parsed_locale = params[:locale_mobility]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  # GET /status or /status.json
  def index
    @map = policy_scope(Map).find_by_slug(params[:id]) || policy_scope(Map).find_by_id(params[:id])
    @status = Status.where(basic: true)
    respond_to do |format|
      if @status
        format.json { render :index }
      else
        format.json { head :no_content }
      end
    end
  end

  # # GET /status/1 or /status/1.json
  # def show
  # end

  # # GET /status/new
  # def new
  #   @status = Status.new
  # end

  # # GET /status/1/edit
  # def edit
  # end

  # # POST /status or /status.json
  # def create

  #   puts 'CHECK'
  #   puts status_params.inspect
  #   @status = Status.new(status_params)

  #   respond_to do |format|
  #     if @status.save
  #       format.html { redirect_to status_url(@status), notice: "Status was successfully created." }
  #       format.json { render :show, status: :created, location: @status }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @status.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /status/1 or /status/1.json
  # def update
  #   respond_to do |format|
  #     if @status.update(status_params)
  #       format.html { redirect_to status_url(@status), notice: "Status was successfully updated." }
  #       format.json { render :show, status: :ok, location: @status }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @status.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /status/1 or /status/1.json
  # def destroy
  #   @status.destroy

  #   respond_to do |format|
  #     format.html { redirect_to status_url, notice: "Status was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_status
    @status = Status.find(params[:id])
  end

  # # Only allow a list of trusted parameters through.
  # def status_params
  #   params.require(:status).permit(:title, :description, :basic, :map_id, locales: [])
  # end
end
