require 'webdack/uuid_migration/helpers'


class MigrateUuid3 < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        primary_key_and_all_references_to_uuid :active_storage_blobs
        primary_key_and_all_references_to_uuid :active_storage_attachments
        primary_key_and_all_references_to_uuid :active_storage_variant_records
        # columns_to_uuid :active_storage_variant_records, :blob_id
        columns_to_uuid :active_storage_attachments, :record_id
        columns_to_uuid :active_storage_attachments, :blob_id
      end

      dir.down do
       # raise ActiveRecord::IrreversibleMigration
      end
    end
  end

end
