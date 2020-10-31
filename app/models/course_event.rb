class CourseEvent < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :category
  belongs_to :course
  belongs_to :room
  belongs_to :trainer
  belongs_to :course_schedule
  belongs_to :auditor, class_name: 'User', optional: true
  has_many :attendees, dependent: :restrict_with_error
  has_many :users, through: :attendees

  accepts_nested_attributes_for :attendees, reject_if: lambda { |obj| obj[:user_id].blank? }, allow_destroy: true

  validates :course_id, uniqueness: { scope: [:room_id, :trainer_id, :event_date] }

  before_validation :set_default

  STATES = { just_made: 10, active: 20, suspended: 30, closed: 40}
  enum state: STATES

  # def attendees_count
  #   attendees.count
  # end

  private

  def set_default
    self.state ||= :active

    if course_schedule
      self.organization ||= course_schedule.organization
      self.category ||= course_schedule.category
      self.course ||= course_schedule.course
      self.trainer ||= course_schedule.trainer
      self.room ||= course_schedule.room
    end
  end
end
