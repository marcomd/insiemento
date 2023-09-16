class Course < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :category
  has_many :course_events, dependent: :restrict_with_error
  has_many :course_schedules, dependent: :restrict_with_error
  has_many :trainers, through: :course_schedules
  has_many :rooms, through: :course_schedules

  validates :name, presence: true
  validates :start_booking_hours, numericality: { only_integer: true, less_than: 10_000, greater_than_or_equal_to: 0 }
  validates :end_booking_minutes, numericality: { only_integer: true, less_than: 10_000, greater_than_or_equal_to: 0 }

  after_initialize :set_default

  STATES = { just_made: 10, active: 20, suspended: 30 }.freeze
  enum state: STATES

  private

  def set_default
    self.start_booking_hours ||= 216
    self.end_booking_minutes ||= 120
    self.state ||= :active
  end
end
