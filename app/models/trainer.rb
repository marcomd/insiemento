class Trainer < ApplicationRecord
  has_many :course_schedules
  has_many :courses, through: :course_schedules

  STATES = { just_made: 10, active: 20, suspended: 30}
  enum state: STATES

  def full_name
    [firstname, lastname].join(' ')
  end
end
