# frozen_string_literal: true

class Api::V1::MapsController < Api::V1::ApplicationController
  # GET /maps.json
  def index
    @maps = Map.published
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
    @map = Map.published.find_by_slug(params[:id]) || Map.published.find_by_id(params[:id])

    respond_to do |format|
      @map_layers = @map.layers if @map&.layers
      if @map_layers.present?
        format.json { render :show, location: @map }
      elsif @map.present?
        format.json { render :show, location: @map }
      else
        # format.json { head :no_content }
        format.json { render json: { error: 'Map not accessible' }, status: :forbidden }
      end
    end
  end
end
