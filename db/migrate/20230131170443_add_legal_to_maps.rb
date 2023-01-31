class AddLegalToMaps < ActiveRecord::Migration[6.1]
  def change
    
    add_column :maps, :moderate, :boolean, default: false
    add_column :maps, :moderate_message, :string, default: ''
    add_column :maps, :hide, :boolean, default: false
    add_column :maps, :hide_message, :string, default: ''

    add_column :maps, :organisation, :string, default: ''
    add_column :maps, :organisation_address, :string, default: ''
    add_column :maps, :organisation_email, :string, default: ''
    add_column :maps, :organisation_url, :string, default: ''
    add_column :maps, :organisation_legal, :string, default: ''
    add_column :maps, :organisation_meeting, :string, default: ''
    add_column :maps, :organisation_intro, :string, default: ''

  end
end
