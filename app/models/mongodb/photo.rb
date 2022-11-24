# frozen_string_literal: true

class Mongodb::Photo
  include Mongoid::Document

  store_in collection: 'photos'  # remember to pluralize the name of your model
end
