class CreateCourseEventComments < ActiveRecord::Migration[6.0]
  def change
    create_table :course_event_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course_event, null: false, foreign_key: true
      t.string :message, limit: 255

      t.timestamps
    end
  end
end
