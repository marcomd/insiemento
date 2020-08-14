class Trainer < ApplicationRecord
  include Stateable

  belongs_to :organization
  has_many :course_schedules
  has_many :courses, through: :course_schedules

  before_validation :set_default

  STATES = { just_made: 10, active: 20, suspended: 30}
  enum state: STATES

  def full_name
    [firstname, lastname].join(' ')
  end

  private

  def set_default
    self.state ||= :active
  end
end
