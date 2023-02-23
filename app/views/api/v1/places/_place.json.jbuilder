# frozen_string_literal: true

json.extract! place, :id, :title, :teaser, :text, :link, :startdate, :enddate, :published, :featured, :sensitive, :layer_id, :created_at, :updated_at, :date, :buildingType, :building_type, :owner, :vacant_since, :degree, :building_usage, :building_part, :building_epoche, :building_floors, :owner_type, :owner_company, :owner_contact
json.extract! place, *policy(place).sensitive_attributes
json.lat place.public_lat
json.lon place.public_lon
if place.user.present?
  json.user do
    json.extract! place.user, *policy(place.user).permitted_attributes
  end
end
json.pict place.images.count
json.images do
  json.array! policy_scope(place.images).order('sorting ASC') do |image|
    json.call(image, :id, :title, :alt, :sorting, :image_url, :image_path, :image_filename)
  end
end
json.comments policy_scope(place.annotations).order('created_at DESC') do |annotation|
  json.extract! annotation, :id, :created_at, :updated_at, :title, :text, :published, :status
  if annotation.user.present?
    json.user do
      json.extract! annotation.user, :id, :nickname
    end
  end
  json.images do
    json.array! policy_scope(annotation.images).order('sorting ASC') do |image|
      json.call(image, :id, :title, :alt, :sorting, :image_url, :image_path, :image_filename)
    end
  end
end
