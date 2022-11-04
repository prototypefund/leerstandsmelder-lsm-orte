class AddAddressDetailsToPlace < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :road, :string
    add_column :places, :house_number, :string
    add_column :places, :borough, :string
    add_column :places, :suburb, :string
    add_column :places, :country_code, :string
  end
end
