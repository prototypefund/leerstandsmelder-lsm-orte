class AddLsmToPlaces < ActiveRecord::Migration[6.1]
  def change
    add_reference :places, :user, foreign_key: true, type: :uuid
    add_column :places, :rumor, :boolean, default: false
    add_column :places, :slug, :string, default: ''
    add_column :places, :emptySince, :string, default: ''
    add_column :places, :buildingType, :string, default: ''
    # TODO: do we need this
    add_reference :places, :map, foreign_key: true, type: :uuid
    add_column :places, :active, :boolean, default: false
    add_column :places, :hidden, :boolean, default: false
    add_column :places, :demolished, :boolean, default: false
    # TODO: do we need this
    add_column :places, :slug_aliases, :string, array:true, default: []
  end
end
