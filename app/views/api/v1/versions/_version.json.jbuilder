# frozen_string_literal: true

json.extract! version, :id, :item_type, :item_id, :event, :created_at, :object_changes
json.user version.whodunnit
