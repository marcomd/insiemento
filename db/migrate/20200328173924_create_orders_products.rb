class CreateOrdersProducts < ActiveRecord::Migration[6.0]
  def change
    # create_table :orders_products, id: false do |t|
    #   t.references :order, null: false, foreign_key: true
    #   t.references :product, null: false, foreign_key: true
    # end
    create_table :order_products do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
    end
  end
end
