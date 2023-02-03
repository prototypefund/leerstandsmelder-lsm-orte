# frozen_string_literal: true

if version_object.versions.length

  json.versions do
    json.array! version_object.all_versions.reverse.first(10) do |version|
      json.call(version, :id, :created_at, :item_type, :event, :whodunnit, :changeset)
    end
  end
else
  json.version 1

end
