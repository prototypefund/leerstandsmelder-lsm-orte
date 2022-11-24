# frozen_string_literal: true

json.array! @maps, partial: 'api/v1/maps/map', as: :map
