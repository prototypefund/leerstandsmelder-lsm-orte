require 'webdack/uuid_migration/helpers'


class MigrateUuid2 < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        primary_key_and_all_references_to_uuid :roles
        # beware that model does not exists in this timeline
        # primary_key_and_all_references_to_uuid :assignments
      end

      dir.down do
       raise ActiveRecord::IrreversibleMigration
      end
    end
  end

end
