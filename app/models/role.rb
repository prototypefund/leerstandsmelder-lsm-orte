# frozen_string_literal: true

class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles

  belongs_to :resource,
             polymorphic: true,
             optional: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify

  def name_with_resource
    if resource_type.blank?
      name
    else
      resource_obj = resource_type.constantize
      resource_instance = resource_obj.find(resource_id)
      resource_label = resource_instance.try(:title)
      "#{name}: #{resource_label}"
      # self.name + '_' + self.resource_type.downcase + '_' + self.resource_id
    end
  end
end
