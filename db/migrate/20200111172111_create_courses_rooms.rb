class CreateCoursesRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :courses_rooms, id: false do |t|
      t.integer :course_id, limit: 4
      t.integer :room_id, limit: 4
    end
  end
end
