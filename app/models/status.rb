# frozen_string_literal: true

class Status < ApplicationRecord
  self.table_name = 'status'

  extend Mobility
  translates :title,        type: :string
  translates :description,  type: :text

  belongs_to :map, optional: true

  serialize :locales, Array
end
