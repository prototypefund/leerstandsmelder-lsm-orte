# frozen_string_literal: true

json.array! @news, partial: 'api/v1/news/news', as: :news
