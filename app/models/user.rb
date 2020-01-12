class User < ApplicationRecord

  has_many :attendees, dependent: :nullify
  has_many :course_events, through: :attendees

  STATES = { just_made: 10, active: 20, suspended: 30}
  enum state: STATES

end
