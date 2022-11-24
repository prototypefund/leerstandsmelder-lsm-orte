# frozen_string_literal: true

class Mongodb::Location
  include Mongoid::Document

  store_in collection: 'locations'  # remember to pluralize the name of your model
end
