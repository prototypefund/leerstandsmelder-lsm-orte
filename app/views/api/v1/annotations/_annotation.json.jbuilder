# frozen_string_literal: true

json.extract! annotation, :id, :created_at, :updated_at, :title, :text, :published
json.user do
  json.extract! annotation.user, :id, :nickname
end
