class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :name, limit: 60
      t.string :description, limit: 255
      t.integer :price_cents, limit: 4
      t.integer :days, limit: 2

      t.timestamps
    end
  end
end
