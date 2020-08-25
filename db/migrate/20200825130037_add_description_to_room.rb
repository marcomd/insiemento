class AddDescriptionToRoom < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :description, :string, limit: 255
  end
end
