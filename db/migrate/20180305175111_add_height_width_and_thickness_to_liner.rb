class AddHeightWidthAndThicknessToLiner < ActiveRecord::Migration[5.1]
  def change
    add_column :liners, :height, :string
    add_column :liners, :width, :string
    add_column :liners, :thickness, :string
  end
end
