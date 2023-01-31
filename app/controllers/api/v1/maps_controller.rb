# frozen_string_literal: true

class Api::V1::MapsController < Api::V1::ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_map, only: %i[show edit new update destroy]

  # GET /maps.json
  def index
    @maps = policy_scope(Map)
    respond_to do |format|
      if @maps
        format.json { render :index, maps: @maps }
      else
        format.json { head :no_content }
      end
    end
  end

  # GET /maps/1.json
  def show
    authorize @map
    respond_to do |format|
      @map_layers = @map.layers if @map&.layers
      # TODO: set a flag to display by layer
      show_by_layer = params[:show_by_layer] || false
      if @map_layers.present? && show_by_layer
        format.json { render :show, map: @map }
      elsif @map.present?
        format.json { render :show_flat, map: @map }
      else
        # format.json { head :no_content }
        format.json { render json: { error: 'Map not accessible' }, status: :forbidden }
      end
    end
  end

  # POST /maps.json
  def create
    authorize Map
    @map = Map.new(map_params)

    respond_to do |format|
      if @map.save
        format.json { render :show_flat, status: :created, map: @map }
      else
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maps/1.json
  def update
    authorize @map
    respond_to do |format|
      if @map.update(map_params)
        format.json { render :show_flat, status: :ok, map: @map }
      else
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_map
    @map = policy_scope(Map).find_by_slug(params[:id]) || policy_scope(Map).find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def map_params
    params.require(:map).permit(:id, :title, :subtitle, :text, :credits, :published, :image, :group_id, :mapcenter_lat, :mapcenter_lon, :zoom, :northeast_corner, :southwest_corner, :iconset_id, :basemap_url, :basemap_attribution, :background_color, :popup_display_mode, :show_annotations_on_map, :preview_url, :enable_privacy_features, :enable_map_to_go, :hide, :hide_message, :moderate, :moderate_message, :organisation, :organisation_address, :organisation_email, :organisation_url, :organisation_legal, :organisation_meeting, :organisation_intro)
  end
end
