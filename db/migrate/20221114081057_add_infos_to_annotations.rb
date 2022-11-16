class AddInfosToAnnotations < ActiveRecord::Migration[6.1]
  def change
    add_column :annotations, :user_id, :string
    add_column :annotations, :to_user_id, :string
    add_column :annotations, :hidden, :boolean, default: false
    add_column :annotations, :legacy_id, :string
  end
end
