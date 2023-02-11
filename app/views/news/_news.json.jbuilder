# frozen_string_literal: true

json.extract! news, :id, :created_at, :updated_at
json.urlse news_url(news, format: :json)
