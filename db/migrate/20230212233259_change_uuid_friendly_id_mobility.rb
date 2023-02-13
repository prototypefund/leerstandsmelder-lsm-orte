require 'webdack/uuid_migration/helpers'

class ChangeUuidFriendlyIdMobility < ActiveRecord::Migration[6.1]
  def change
      reversible do |dir|
        dir.up do
          columns_to_uuid :mobility_string_translations, :translatable_id
          columns_to_uuid :mobility_text_translations, :translatable_id
          columns_to_uuid :friendly_id_slugs, :sluggable_id
        end
  
        dir.down do
         raise ActiveRecord::IrreversibleMigration
        end
      end
  

  end
end


