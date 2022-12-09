class AddLsmToImage < ActiveRecord::Migration[6.1]
  def change
    add_reference :images, :user, foreign_key: false, type: :uuid
    add_column :images, :filename, :string, default: ''
    add_column :images, :extension, :string, default: ''
    add_column :images, :mime_type, :string, default: ''
    add_column :images, :filehash, :string, default: ''
    add_column :images, :size, :string, default: ''
    add_column :images, :hidden, :boolean, default: false
  end
end
