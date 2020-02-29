class Course < ApplicationRecord
  belongs_to :organization
  has_many :course_schedules
  has_many :trainers, through: :course_schedules
  has_many :rooms, through: :course_schedules

  STATES = { just_made: 10, active: 20, suspended: 30}
  enum state: STATES
end
