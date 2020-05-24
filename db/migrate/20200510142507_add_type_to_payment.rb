class AddTypeToPayment < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :type, :integer, limit: 1
    add_column :payments, :external_service_response, :json, default: {}
  end
end
