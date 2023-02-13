# frozen_string_literal: true

json.array! @status, partial: 'api/v1/status/status', as: :status
