class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name, limit: 30
      t.text :description
      t.integer :start_booking_hours, limit: 2
      t.integer :end_booking_minutes, limit: 2

      t.timestamps
    end
  end
end
