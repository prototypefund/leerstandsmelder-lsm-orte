# frozen_string_literal: true

json.array! @versions, partial: 'api/v1/versions/version', as: :version
