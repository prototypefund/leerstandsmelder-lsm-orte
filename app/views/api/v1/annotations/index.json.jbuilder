# frozen_string_literal: true

json.array! @annotations, partial: 'api/v1/annotations/annotation', as: :annotation
