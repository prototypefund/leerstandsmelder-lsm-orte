require 'webdack/uuid_migration/helpers'

class MigrateRelationId < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        columns_to_uuid :relations, :relation_from_id, :relation_to_id
        columns_to_uuid :taggings, :taggable_id
      end

      dir.down do
        #raise ActiveRecord::IrreversibleMigration
      end
    end  
  end
end
