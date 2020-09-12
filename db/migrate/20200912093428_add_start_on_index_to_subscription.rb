class AddStartOnIndexToSubscription < ActiveRecord::Migration[6.0]
  def change
    add_index :subscriptions, [:start_on, :end_on]
  end
end
