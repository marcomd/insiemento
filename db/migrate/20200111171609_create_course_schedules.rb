class CreateCourseSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :course_schedules do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :trainer, null: true, foreign_key: true
      t.integer :event_day, limit: 1
      t.time :event_time
      t.integer :state, limit: 1, default: 10

      t.timestamps
    end
  end
end
