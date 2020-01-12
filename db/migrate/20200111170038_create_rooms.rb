class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :name, limit: 30
      t.integer :max_attendees, limit: 1
      t.integer :state, limit: 1

      t.timestamps
    end
  end
end
