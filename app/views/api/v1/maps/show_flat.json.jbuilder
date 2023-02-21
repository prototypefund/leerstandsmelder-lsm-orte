# frozen_string_literal: true

json.map do
  json.call(@map, :id, :title, :slug, :subtitle, :text, :credits, :image_link, :created_at, :updated_at, :published, :mapcenter_lat, :mapcenter_lon, :zoom, :hide, :hide_message, :moderate, :moderate_message, :organisation, :organisation_address, :organisation_email, :organisation_url, :organisation_legal, :organisation_meeting, :organisation_intro)
  json.owner @map.group.title if @map.group&.title
  json.status @map.map_status
  json.iconset @map.iconset, :title, :icon_anchor, :icon_size, :popup_anchor, :class_name if @map.iconset
  json.default_layer @map.layers&.published&.first&.id
  json.places do
    json.array! policy_scope(@map.places) do |place|
      json.call(place, :id, :created_at, :updated_at, :title, :teaser, :published, :buildingType, :owner, :startdate, :enddate, :text, :featured, :shy, :layer_id, :user_id)
      json.lat place.public_lat
      json.lon place.public_lon
    end
  end
end
