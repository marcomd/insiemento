class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :firstname, limit: 30
      t.string :lastname, limit: 30
      t.date :birthdate
      t.string :gender, limit: 1
      t.integer :state, limit: 1, default: 10
      t.string :phone, limit: 15

      t.timestamps
    end
    # add_index :users, :email
  end
end
