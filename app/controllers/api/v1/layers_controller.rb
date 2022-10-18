# frozen_string_literal: true

class Api::V1::LayersController < ActionController::Base
  # GET /maps/1/layers/1.json
  def show
    @layer = Layer.published.find_by_slug(params[:id]) || Layer.published.find_by_id(params[:id])

    if @layer
      @places = case @layer.places_sort_order
                when 'startdate'
                  @layer.places.published.sorted_by_startdate
                when 'title'
                  @layer.places.published.sorted_by_title
                else
                  @layer.places.published
                end
    end

    respond_to do |format|
      if @layer.present?
        format.json { render :show }
        format.geojson { render :show, mime_type: Mime::Type.lookup('application/geo+json') }
        format.zip do
          zip_file = "orte-map-#{@layer.map.title.parameterize}-layer-#{@layer.title.parameterize}-#{I18n.l Date.today}.zip"
          @layer.to_zip(zip_file)
          send_file "#{Rails.root}/public/#{zip_file}"
        end
      else
        # format.json { head :no_content }
        format.json { render json: { error: 'Layer not accessible' }, status: :forbidden }
        format.geojson { render json: { error: 'Layer not accessible' }, status: :forbidden }
      end
    end
  end
end
