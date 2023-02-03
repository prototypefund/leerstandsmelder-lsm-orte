# frozen_string_literal: true

json.partial! 'api/v1/places/place', place: @place
puts 'yalla1'
json.partial! 'api/v1/shared/versions', version_object: @place
