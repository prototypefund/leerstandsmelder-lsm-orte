# frozen_string_literal: true

json.map do
  json.call(@map, :id, :title, :subtitle, :text, :credits, :image_link, :created_at, :updated_at, :published, :mapcenter_lat, :mapcenter_lon, :zoom)
  json.owner @map.group.title
  json.iconset @map.iconset, :title, :icon_anchor, :icon_size, :popup_anchor, :class_name if @map.iconset
  json.default_layer @map.layers.published.first.id
  json.places do
    json.array! policy_scope(@map.places) do |place|
      json.call(place, :id, :created_at, :updated_at, :title, :teaser, :published, :buildingType, :owner, :startdate, :enddate, :location, :address, :zip, :city, :text, :country, :featured, :shy, :layer_id, :user_id)
      json.lat place.public_lat
      json.lon place.public_lon
    end
  end
end
