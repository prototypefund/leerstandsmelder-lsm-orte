# frozen_string_literal: true

json.extract! place, :id, :title, :teaser, :text, :link, :startdate, :enddate, :full_address, :location, :address, :zip, :city, :country, :published, :featured, :layer_id, :created_at, :updated_at, :date, :edit_link, :show_link, :imagelink2, :imagelink, :icon_link, :icon_class, :icon_name
json.lat place.public_lat
json.lon place.public_lon
json.images(place.images).order('sorting ASC') do |image|
  json.image_url rails_blob_path(image) if image.file&.attached?
end
