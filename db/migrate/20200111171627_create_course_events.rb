class CreateCourseEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :course_events do |t|
      t.references :course, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :trainer, null: false, foreign_key: true
      t.references :course_schedule, null: false, foreign_key: true
      t.datetime :event_date

      t.timestamps
    end
  end
end
