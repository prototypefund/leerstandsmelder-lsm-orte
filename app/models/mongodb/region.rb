class Mongodb::Region
  include Mongoid::Document
  
  store_in collection: 'regions'  #remember to pluralize the name of your model
end