class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.references :company, foreign_key: true
      t.string :password_digest

      t.timestamps
    end
  end
end
