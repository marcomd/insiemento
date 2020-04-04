class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.string :code, limit: 14
      t.references :organization, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.references :order, null: true, foreign_key: true
      t.date :start_on
      t.date :end_on

      t.timestamps
    end
    add_index :subscriptions, :code, unique: true
  end
end
