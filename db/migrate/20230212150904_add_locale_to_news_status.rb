class AddLocaleToNewsStatus < ActiveRecord::Migration[6.1]
  def change
    add_column :status, :locales, :string
    add_column :news, :locales, :string
  end
end
