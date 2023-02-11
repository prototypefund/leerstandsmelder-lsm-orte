# frozen_string_literal: true

class NewsMap < ApplicationRecord
  belongs_to :map
  belongs_to :news
end
