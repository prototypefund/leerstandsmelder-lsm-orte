require 'webdack/uuid_migration/helpers'


class AddUuidToImage < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
     
        primary_key_and_all_references_to_uuid :images
      end

      dir.down do
        raise ActiveRecord::IrreversibleMigration
      end
    end
  end
end