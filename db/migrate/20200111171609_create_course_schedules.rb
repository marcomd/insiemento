class CreateCourseSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :course_schedules do |t|
      t.references :course, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :trainer, null: false, foreign_key: true
      t.integer :event_day, limit: 1
      t.time :event_time

      t.timestamps
    end
  end
end
