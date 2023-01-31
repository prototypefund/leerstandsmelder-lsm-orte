# frozen_string_literal: true

json.extract! map, :id, :title, :subtitle, :text, :credits, :image_link, :published, :group_id, :created_at, :updated_at, :mapcenter_lat, :mapcenter_lon, :zoom
json.locations map.places.size
