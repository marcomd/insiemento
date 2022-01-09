class CourseSchedule < ApplicationRecord
  include Stateable
  include Suspendable

  belongs_to :organization
  belongs_to :category
  belongs_to :course
  belongs_to :room
  belongs_to :trainer

  has_many :course_events, dependent: :restrict_with_error

  before_validation :set_default

  EVENT_DAYS = {
      sunday: 0,
      monday: 1,
      tuesday: 2,
      wednesday: 3,
      thursday: 4,
      friday: 5,
      saturday: 6,
  }
  enum event_day: EVENT_DAYS

  STATES = { just_made: 10, active: 20, suspended: 30}
  enum state: STATES

  validates :event_time, uniqueness: { scope: [:organization_id, :category_id, :course_id, :room_id, :trainer_id, :event_day, :event_time] }

  def name
    "#{course.name} #{event_day} #{event_time.strftime('%H:%M')}"
  end

  def next_event_date(date)
    next_date = date + ((EVENT_DAYS[event_day.to_sym] - date.wday) % 7)
    # Discard starting date, we start using next wday
    next_date == date ? next_date + 7 : next_date
  end

  def next_event_datetime(date=Time.zone.today)
    Time.zone.parse("#{next_event_date(date).strftime('%Y-%m-%d')} #{event_time_short}")
  end

  def event_time_short
    self.event_time.strftime('%H:%M') if self.event_time
  end

  def localized_event_day
    I18n.t('date.day_names')[read_attribute_before_type_cast(:event_day)]
  end

  class << self
    def localized_event_days
      EVENT_DAYS.values.map do |day_value|
        [ I18n.t('date.day_names')[day_value], day_value]
      end
    end
  end

  private

  def set_default
    self.state ||= :active
  end
end
