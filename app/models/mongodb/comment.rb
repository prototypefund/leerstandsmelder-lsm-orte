class Mongodb::Comment
  include Mongoid::Document
  
  store_in collection: 'comments'  #remember to pluralize the name of your model
end