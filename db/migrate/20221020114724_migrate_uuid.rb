require 'webdack/uuid_migration/helpers'


class MigrateUuid < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
     
        primary_key_and_all_references_to_uuid :maps
        primary_key_and_all_references_to_uuid :layers
        primary_key_and_all_references_to_uuid :places
        primary_key_and_all_references_to_uuid :users
        primary_key_and_all_references_to_uuid :annotations
        primary_key_and_all_references_to_uuid :groups
        primary_key_and_all_references_to_uuid :people
        primary_key_and_all_references_to_uuid :relations
        primary_key_and_all_references_to_uuid :submissions
        primary_key_and_all_references_to_uuid :submissions
        primary_key_and_all_references_to_uuid :roles
        primary_key_and_all_references_to_uuid :assignments
      end

      dir.down do
       # raise ActiveRecord::IrreversibleMigration
      end
    end
  end
  
end
