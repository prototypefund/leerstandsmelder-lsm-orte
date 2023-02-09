# frozen_string_literal: true

json.extract! annotation, :id, :created_at, :updated_at, :title, :text, :published, :status
if annotation.user.present?
  json.user do
    json.extract! annotation.user, :id, :nickname
  end
end
json.images do
  json.array! policy_scope(annotation.images).order('sorting ASC') do |image|
    json.call(image, :id, :title, :source, :creator, :alt, :sorting, :image_linktag, :image_url, :image_path, :image_filename)
  end
end
