class CreateLiners < ActiveRecord::Migration[5.1]
  def change
    create_table :liners do |t|
      t.string :liner_reference
      t.references :company, foreign_key: true
      t.string :location
      t.string :row
      t.string :collumn
      t.string :structure
      t.string :plant

      t.timestamps
    end
  end
end
