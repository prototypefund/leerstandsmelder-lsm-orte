class CreateStatus < ActiveRecord::Migration[6.1]
  def change
    create_table :status, id: :uuid do |t|
      t.string :title
      t.text :description
      t.boolean :basic
      t.boolean :published, default: true
      t.references :map, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
