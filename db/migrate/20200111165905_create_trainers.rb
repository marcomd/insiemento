class CreateTrainers < ActiveRecord::Migration[6.0]
  def change
    create_table :trainers do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :firstname, limit: 30
      t.string :lastname, limit: 30
      t.string :nickname, limit: 30
      t.text :bio
      t.integer :state, limit: 1, default: 10

      t.timestamps
    end
  end
end
