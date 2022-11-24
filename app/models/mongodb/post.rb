# frozen_string_literal: true

class Mongodb::Post
  include Mongoid::Document

  store_in collection: 'posts'  # remember to pluralize the name of your model
end
