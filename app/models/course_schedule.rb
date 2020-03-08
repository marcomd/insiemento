class CourseSchedule < ApplicationRecord
  belongs_to :organization
  belongs_to :category
  belongs_to :course
  belongs_to :room
  belongs_to :trainer

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

  def name
    "#{event_day} #{event_time.strftime('%H:%M')}"
  end

  def next_event_date(date)
    next_date = date + ((EVENT_DAYS[event_day.to_sym] - date.wday) % 7)
    # Discard starting date, we start using next wday
    next_date == date ? next_date + 7 : next_date
  end

  def next_event_datetime(date=Time.zone.today)
    Time.zone.parse("#{next_event_date(date).strftime('%Y-%m-%d')} #{event_time}")
  end
end
