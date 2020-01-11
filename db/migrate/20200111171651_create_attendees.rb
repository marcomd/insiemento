class CreateAttendees < ActiveRecord::Migration[6.0]
  def change
    create_table :attendees do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course_event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
