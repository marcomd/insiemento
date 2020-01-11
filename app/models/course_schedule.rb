class CourseSchedule < ApplicationRecord
  belongs_to :course
  belongs_to :room
  belongs_to :trainer

  EVENT_DAYS = {
      monday: 1,
      tuesday: 2,
      wednesday: 3,
      thursday: 4,
      friday: 5,
      saturday: 6,
      sunday: 7,
  }

  enum event_day: EVENT_DAYS

  def name
    "#{event_day} #{event_time.strftime('%H:%M')}"
  end

  def next_event_date
    date  = Date.parse(event_day)
    delta = date > Date.today ? 0 : 7
    date + delta
  end

  def next_event_datetime
    Time.zone.parse("#{next_event_date.strftime('%Y-%m-%d')} #{event_time}")
  end
end
