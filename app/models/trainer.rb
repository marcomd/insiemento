class Trainer < ApplicationRecord
  has_and_belongs_to_many :courses

  STATES = { just_made: 10, active: 20, suspended: 30}
  enum state: STATES

  def full_name
    [firstname, lastname].join(' ')
  end
end
