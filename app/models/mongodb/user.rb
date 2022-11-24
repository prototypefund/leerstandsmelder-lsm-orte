# frozen_string_literal: true

class Mongodb::User
  include Mongoid::Document

  store_in collection: 'users'  # remember to pluralize the name of your model
end
