# frozen_string_literal: true

class Api::V1::ImagesController < Api::V1::ApplicationController
  before_action :set_image, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  # GET /images.json
  def index
    @place = policy_scope(Place).where(id: params[:place_id]).first
    @images = policy_scope(Image).where(place_id: @place.id).order(:created_at)
  end

  # GET /images/1.json
  def show; end

  # POST /images.json
  def create
    authorize Image
    @image = Image.new(item_params)
    attach_picture(@image) if image_params[:file].present?
    @place = Place.find(params[:place_id])
    authorize @place
    respond_to do |format|
      if @image.save
        format.json { render :show, status: :created, image: @image }
      else
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1.json
  def update
    params[:image][:preview] = default_checkbox(params[:image][:preview])
    respond_to do |format|
      if @image.update(image_params)
        format.json { render :show, status: :ok, image: @image }
      else
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @map = policy_scope(Map).friendly.find(params[:map_id]) if params[:map_id]
    @layer = policy_scope(Layer).friendly.find(params[:layer_id]) if params[:layer_id]
    @place = Place.find(params[:place_id])
    authorize @place
    @image = Image.find(params[:id])
    authorize @image
  end

  def attach_picture(image)
    image.file.attach(image_params[:file])
  end

  def item_params
    {
      title: image_params[:title],
      place_id: image_params[:place_id],
      source: image_params[:source]
    }
  end

  # Only allow a list of trusted parameters through.
  def image_params
    params.permit(:title, :licence, :source, :creator, :place_id, :alt, :caption, :sorting, :preview, :file, :itype)
  end
end
