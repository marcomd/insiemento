class CourseEvent < ApplicationRecord
  belongs_to :course
  belongs_to :room
  belongs_to :trainer
  belongs_to :course_schedule
end
