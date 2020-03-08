class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, limit: 60

      t.timestamps
    end
  end
end
