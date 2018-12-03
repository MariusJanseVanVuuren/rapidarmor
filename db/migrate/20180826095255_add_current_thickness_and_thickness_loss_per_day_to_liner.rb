class AddCurrentThicknessAndThicknessLossPerDayToLiner < ActiveRecord::Migration[5.1]
  def change
    add_column :liners, :current_thickness, :Float
    add_column :liners, :thickness_loss_per_day, :Float
    add_column :liners, :description, :string
    rename_column :liners, :thickness, :original_thickness
  end
end
