class AddLsmToAnnotations < ActiveRecord::Migration[6.1]
  def change
    # Status: Leerstand, Abgerissen, Neubau, Vermietet, Zwischennutzung, Bauarbeiten
    add_column :annotations, :status, :string, default: ''

    add_reference :annotations, :image, foreign_key: true, type: :uuid
  end
end
