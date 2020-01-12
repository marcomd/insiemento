class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :firstname, limit: 30
      t.string :lastname, limit: 30
      t.string :email, limit: 60
      t.date :birtdate
      t.string :gender, limit: 1
      t.integer :state, limit: 1, default: 10

      t.timestamps
    end
    add_index :users, :email
  end
end
