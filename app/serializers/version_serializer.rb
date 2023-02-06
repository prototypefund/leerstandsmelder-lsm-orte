# frozen_string_literal: true

class VersionSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :item_id, :item_type, :event, :created_at, :object_changes
end
