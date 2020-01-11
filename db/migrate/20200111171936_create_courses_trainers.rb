class CreateCoursesTrainers < ActiveRecord::Migration[6.0]
  def change
    create_table :courses_trainers, id: false do |t|
      t.integer :course_id, limit: 4
      t.integer :trainer_id, limit: 4
    end
  end
end
