class Course < ApplicationRecord
  has_and_belongs_to_many :rooms
  has_and_belongs_to_many :trainers

  STATES = { just_made: 10, active: 20, suspended: 30}
  enum state: STATES
end
