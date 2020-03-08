class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :name, limit: 30
      t.text :description
      t.integer :start_booking_hours, limit: 2
      t.integer :end_booking_minutes, limit: 2
      t.integer :state, limit: 1, default: 10

      t.timestamps
    end
  end
end
