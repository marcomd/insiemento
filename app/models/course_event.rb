class CourseEvent < ApplicationRecord
  belongs_to :course
  belongs_to :room
  belongs_to :trainer
  belongs_to :course_schedule

  STATES = { just_made: 10, active: 20, suspended: 30}
  enum state: STATES

end
