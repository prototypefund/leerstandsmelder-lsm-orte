# frozen_string_literal: true

class Api::V1::MapsController < Api::V1::ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  before_action :cors_set_access_control_headers

  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    # headers['Access-Control-Allow-Origin'] = '*'
    # headers['Access-Control-Allow-Methods'] = 'GET'
    # headers['Access-Control-Request-Method'] = '*'
    # headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  # GET /maps.json
  def index
    @maps = policy_scope(Map)
    respond_to do |format|
      if @maps
        format.json { render json: @maps }
      else
        format.json { head :no_content }
      end
    end
  end

  # GET /maps/1.json
  def show
    @map = policy_scope(Map).find_by_slug(params[:id]) || policy_scope(Map).find_by_id(params[:id])

    authorize @map
    respond_to do |format|
      @map_layers = @map.layers if @map&.layers
      # TODO: set a flag to display by layer
      show_by_layer = params[:show_by_layer] || false
      if @map_layers.present? && show_by_layer
        format.json { render :show, location: @map }
      elsif @map.present?
        format.json { render :show_flat, location: @map }
      else
        # format.json { head :no_content }
        format.json { render json: { error: 'Map not accessible' }, status: :forbidden }
      end
    end
  end
end
