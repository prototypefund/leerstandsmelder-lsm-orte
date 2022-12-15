# frozen_string_literal: true

class Api::V1::PlacesController < Api::V1::ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_place, only: %i[show edit clone edit_clone update_clone update destroy]

  before_action :cors_set_access_control_headers

  # GET /places
  # GET /places.json
  def index
    @layer = policy_scope(Layer).friendly.find(params[:layer_id])
    @map = @layer.map
    @places = policy_scope(@layer.places)
    # authorize @places
    respond_to do |format|
      if @places
        format.json { render :index, json: @places }
      else
        format.json { head :no_content }
      end
    end
  end

  def user_places
    @user = User.find(params[:user_id])
    @places = policy_scope(@user.places)
    # authorize @places
    respond_to do |format|
      if @places
        format.json { render :index, json: @places }
      else
        format.json { head :no_content }
      end
    end
  end

  # GET /places/1
  # GET /places/1.json
  def show; end

  # GET /places/new
  def new
    @place = Place.new
    @place.location = params[:location]
    @place.address = params[:address]
    @place.zip = params[:zip] || params[:postcode]
    @place.city = params[:city]
    @place.lat = params[:lat]
    @place.lon = params[:lon]
    @place.layer_id = params[:layer_id]
    @place.user = current_user
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
  end

  # GET /places/1/edit
  def edit
    if @place.startdate
      @place.startdate_date = @place.startdate.to_date
      @place.startdate_time = @place.startdate.to_time
    end

    if @place.enddate
      @place.enddate_date = @place.enddate.to_date
      @place.enddate_time = @place.enddate.to_time
    end

    return unless params[:lat].present?

    flash[:notice] = "Re-Map: Got new coordinates and address data. Please check all fields and click 'Update place'"
    @old_place = @place.dup
    @place.location = params[:location]
    @place.address = params[:address]
    @place.zip = params[:zip] || params[:postcode]
    @place.city = params[:city]
    @place.lat = params[:lat]
    @place.lon = params[:lon]
    @place.layer_id = params[:layer_id]
    @map = Map.by_user(current_user).friendly.find(params[:map_id])
    @layer = Layer.friendly.find(params[:layer_id])
  end

  # POST /places
  # POST /places.json
  def create
    authorize Place
    @place = Place.new(place_params)
    @place.user = current_user
    @layer = Layer.friendly.find(@place.layer_id)
    authorize @layer
    @map = @layer.map

    respond_to do |format|
      if @place.save
        format.json { render :show, status: :created, place: @place }
      else
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    @layer = @place.layer
    @map = @place.layer.map

    # TODO: render this at generating the form
    params[:place][:published] = default_checkbox(params[:place][:published])
    params[:place][:featured] = default_checkbox(params[:place][:featured])
    params[:place][:sensitive] = default_checkbox(params[:place][:sensitive])
    respond_to do |format|
      if @place.update(place_params)
        @place.update({ 'published' => params[:place][:published] })
        format.json { render :show, status: :ok, place: @place }
      else
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def delete_image_attachment
    @image = ActiveStorage::Blob.find_signed(params[:signed_id])
    @image.attachments.first.purge
    redirect_to transition_path, notice: 'Image attachement has been purged'
  end

  def sort
    @image_ids = params[:images]
    n = 1
    ActiveRecord::Base.transaction do
      @image_ids.each do |dom_id|
        # dom_id is like "image_20"
        id = dom_id.gsub('image_', '')
        image = Image.find(id)
        image.sorting = n
        n += 1
        image.save
      end
    end
    render json: {}
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @map = policy_scope(Map).friendly.find(params[:map_id]) if params[:map_id]
    @layer = policy_scope(Layer).friendly.find(params[:layer_id]) if params[:layer_id]
    @place = Place.find(params[:id])
    authorize @place
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def place_params
    params.require(:place).permit(:user_id, :title, :teaser, :text, :link, :startdate, :startdate_date, :startdate_time, :enddate, :enddate_date, :enddate_time, :lat, :lon, :location, :address, :zip, :city, :road, :house_number, :borough, :suburb, :country_code, :country, :published, :featured, :sensitive, :sensitive_radius, :shy, :imagelink, :layer_id, :icon_id, :audio, :relations_tos, :relations_froms, annotations_attributes: %i[title text person_id source], tag_list: [], images: [], videos: [])
  end
end