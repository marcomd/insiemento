class AddChildFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :child_firstname, :string, limit: 32
    add_column :users, :child_lastname, :string, limit: 32
    add_column :users, :child_birthdate, :date
  end
end
