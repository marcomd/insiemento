class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name, limit: 60
      t.string :payoff, limit: 255
      t.string :email, limit: 100
      t.string :phone, limit: 15
      t.string :domain, limit: 100
      t.jsonb :theme
      t.integer :state, limit: 1

      t.timestamps
    end
  end
end
