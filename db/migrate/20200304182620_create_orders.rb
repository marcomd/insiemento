class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :state, limit: 1, default: 10
      t.integer :total_amount_cents, limit: 4, default: 0
      t.integer :amount_to_pay_cents, limit: 4, default: 0
      t.integer :amount_paid_cents, limit: 4, default: 0
      t.integer :discount_cents, limit: 4, default: 0
      t.integer :currency, limit: 1, default: 0
      t.date :start_on
      t.datetime :paid_at
      t.references :approver_admin_user, null: true, foreign_key: { to_table: :admin_users }

      t.timestamps
    end
  end
end
