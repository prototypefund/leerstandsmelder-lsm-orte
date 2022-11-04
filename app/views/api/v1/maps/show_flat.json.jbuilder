# frozen_string_literal: true

json.map do
  json.call(@map, :id, :title, :subtitle, :text, :credits, :image_link, :created_at, :updated_at, :published, :mapcenter_lat, :mapcenter_lon, :zoom)
  json.owner @map.group.title
  json.iconset @map.iconset, :title, :icon_anchor, :icon_size, :popup_anchor, :class_name if @map.iconset
  json.default_layer @map.layers.published.first.id
  json.places do
    json.array! policy_scope(@map.places) do |place|
      json.call(place, :id, :created_at, :updated_at, :title, :teaser, :link, :imagelink, :imagelink2, :audiolink, :published, :startdate, :enddate, :location, :address, :zip, :city, :text, :country, :featured, :shy, :layer_id, :icon_link, :icon_class, :icon_name)
      json.lat place.public_lat
      json.lon place.public_lon
      json.annotations place.annotations do |annotation|
        json.extract! annotation, :id, :title, :text, :person_name, :audiolink
      end
      json.images do
        json.array! place.images.order('sorting ASC') do |image|
          json.call(image, :id, :title, :source, :creator, :alt, :sorting, :image_linktag, :image_url)
        end
      end
    end
  end
end
