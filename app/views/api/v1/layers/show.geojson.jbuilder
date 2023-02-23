# frozen_string_literal: true

if @layer&.published
  json.type 'FeatureCollection'
  json.title @layer.title
  json.text @layer.text
  json.id @layer.id

  json.features @layer.places.order('created_at DESC') do |place|
    next unless place.published

    json.type 'Feature'
    json.geometry do
      json.type 'Point'
      json.coordinates [place.public_lon.to_f, place.public_lat.to_f]
    end
    json.properties do
      json.call(place, :id, :created_at, :updated_at, :since, :title, :slug, :published, :buildingType, :building_type, :owner, :zip, :startdate, :enddate, :text, :featured, :shy, :layer_id, :user_id)
      json.call(place.images.first, :thumb_url) if place.images.first
    end
  end
end
