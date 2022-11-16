# frozen_string_literal: true

json.extract! place, :id, :title, :teaser, :text, :link, :startdate, :enddate, :full_address, :location, :address, :zip, :city, :country, :published, :featured, :layer_id, :created_at, :updated_at, :date
json.lat place.public_lat
json.lon place.public_lon
json.images do
  json.array! policy_scope(place.images).order('sorting ASC') do |image|
    json.call(image, :id, :title, :source, :creator, :alt, :sorting, :image_linktag, :image_url, :image_path, :image_filename)
  end
end
json.comments policy_scope(place.annotations) do |annotation|
  json.extract! annotation, :id, :created_at, :updated_at, :title, :text, :person_name, :audiolink, :published
end
