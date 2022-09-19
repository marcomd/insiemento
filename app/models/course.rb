class Course < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :category
  has_many :course_events, dependent: :restrict_with_error
  has_many :course_schedules, dependent: :restrict_with_error
  has_many :trainers, through: :course_schedules
  has_many :rooms, through: :course_schedules

  before_validation :set_default

  STATES = { just_made: 10, active: 20, suspended: 30 }.freeze
  enum state: STATES

  private

  def set_default
    self.state ||= :active
  end
end
