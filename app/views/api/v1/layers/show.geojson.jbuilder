# frozen_string_literal: true

if @layer&.published
  json.type 'FeatureCollection'
  json.title @layer.title
  json.text @layer.text
  json.id @layer.id

  json.features @layer.places do |place|
    next unless place.published

    json.type 'Feature'
    json.geometry do
      json.type 'Point'
      json.coordinates [place.public_lon.to_f, place.public_lat.to_f]
    end
    json.properties do
      json.call(place, :id, :created_at, :updated_at, :title, :published, :buildingType, :owner, :startdate, :enddate, :text, :featured, :shy, :layer_id, :user_id)

      # json.link place.link
      # json.images do
      #  json.array! place.images do |image|
      #    json.call(image, :id, :title, :source, :creator, :alt, :sorting, :image_linktag, :image_url)
      #  end
      # end
    end
  end
end
