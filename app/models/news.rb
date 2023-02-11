# frozen_string_literal: true

class News < ApplicationRecord
  has_many :news_map
  has_many :maps, through: :news_map
  belongs_to :user
end
