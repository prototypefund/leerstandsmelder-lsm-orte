class CreateNews < ActiveRecord::Migration[6.1]
  def change
    create_table :news, id: :uuid do |t|
      t.string :title
      t.text :body
      t.boolean :published, default: false
      t.references :user, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
    create_table :news_maps, id: :uuid do |t|
      t.belongs_to :news, type: :uuid
      t.belongs_to :map, type: :uuid

      t.timestamps
    end
  end

  
end
