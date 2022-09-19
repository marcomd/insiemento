class AddManyFields < ActiveRecord::Migration[6.0]
  def change
    add_reference :attendees, :subscription, null: true, foreign_key: true
    add_column :products, :product_type, :integer, limit: 1
    add_column :products, :state, :integer, limit: 1
    add_column :products, :max_accesses_number, :integer, limit: 2
    add_column :subscriptions, :subscription_type, :integer, limit: 1
    add_column :subscriptions, :state, :integer, limit: 1
    add_column :subscriptions, :max_accesses_number, :integer, limit: 2
    add_index :products, :product_type
    add_index :products, :state
    add_index :subscriptions, :subscription_type
    add_index :subscriptions, :state

    reversible do |dir|
      dir.up do
        Attendee.find_in_batches(batch_size: 500) do |group|
          group.each do |attendee|
            course_event = attendee.course_event
            # subscription = Subscription.where(category_id: course_event.category_id, user_id: attendee.user_id)
            subscription = attendee.user.active_subscriptions.where(category_id: course_event.category_id).first
            attendee.update_column(:subscription_id, subscription.id)
          end
        end
        Product.update_all product_type: :fee, state: :active
        Subscription.update_all subscription_type: :fee, state: :active

        change_column_null :attendees, :subscription_id, false
        change_column_null :products, :product_type, false
        change_column_null :subscriptions, :subscription_type, false
      end
    end
  end
end
