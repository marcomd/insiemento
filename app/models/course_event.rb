class CourseEvent < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :category
  belongs_to :course
  belongs_to :room
  belongs_to :trainer
  belongs_to :course_schedule
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees

  validates :course_id, uniqueness: { scope: [:room_id, :trainer_id, :event_date],
                                 message: 'already exists' }

  before_validation :set_default

  STATES = { just_made: 10, active: 20, suspended: 30, closed: 40}
  enum state: STATES

  def attendees_count
    attendees.count
  end

  private

  def set_default
    self.state ||= :active
  end
end
