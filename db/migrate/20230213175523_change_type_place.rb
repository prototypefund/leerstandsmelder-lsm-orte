class ChangeTypePlace < ActiveRecord::Migration[6.1]
  def change
    # change_column :places, :buildingType,:string, array:true, default: [], using: "(string_to_array('buildingType', ','))"
    add_column :places, :building_type, :string, array:true, default: []

  end
end
