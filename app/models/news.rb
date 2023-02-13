# frozen_string_literal: true

class News < ApplicationRecord
  has_many :news_map
  has_many :maps, through: :news_map
  belongs_to :user, optional: true

  validates_presence_of :title, :slug

  extend FriendlyId
  friendly_id :slug_candidates, use: :history

  def slug_candidates
    [
      :title,
      %i[title id]

    ]
  end
end
