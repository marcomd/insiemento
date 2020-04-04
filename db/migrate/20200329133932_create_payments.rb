class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.references :order, null: true, foreign_key: true
      t.integer :source, limit: 1
      t.integer :state, limit: 1, default: 10
      t.integer :amount_cents, limit: 4

      t.timestamps
    end
  end
end
