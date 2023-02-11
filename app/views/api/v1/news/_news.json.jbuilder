# frozen_string_literal: true

json.extract! news, :id, :created_at, :updated_at, :title, :body, :map_ids
json.url api_v1_news_url(news, format: :json)
