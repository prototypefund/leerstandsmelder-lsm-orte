class AddLsmToPlacesExtended < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :vacant_since, :date
    # teilweise / vollständig
    add_column :places, :degree, :string, default: ''
    # Wohnfläche, Gewerbefläche, Andere 
    add_column :places, :building_usage, :string, default: ''
    # Vorderhaus, Quergebäude/HInterhaus/Gartenhaus, Seitenflügel, Etage 
    add_column :places, :building_part, :string, default: ''
    # Altbau / Neubau
    add_column :places, :building_epoche, :string, default: ''
    
    add_column :places, :building_floors, :integer, default: ''

    # privat / gewerblich
    add_column :places, :owner_type, :string, default: ''
    # Firmenname / Name
    add_column :places, :owner_company, :string, default: ''
    add_column :places, :owner_contact, :string, default: ''

    add_column :places, :osm_place_id, :string, default: ''

  end
end
