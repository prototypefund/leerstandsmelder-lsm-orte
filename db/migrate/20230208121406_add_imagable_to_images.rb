class AddImagableToImages < ActiveRecord::Migration[6.1]
  def change

    add_reference :images, :imageable, polymorphic: true, index: true, type: :uuid

  end
end
