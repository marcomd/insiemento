class AddStartOnIndexToSubscription < ActiveRecord::Migration[6.0]
  def change
    add_index :subscriptions, %i[start_on end_on]
  end
end
