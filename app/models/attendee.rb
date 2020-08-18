class Attendee < ApplicationRecord
  belongs_to :user
  belongs_to :course_event
  has_one :room, through: :course_event
  has_one :course, through: :course_event
  has_many :attendees, through: :course_event

  validates :course_event_id, uniqueness: { scope: :user_id,
                                 message: I18n.t('errors.messages.already_subscribed') }
  validate :check_max_attendees, :check_valid_subscriptions
  attr_accessor :disable_bookability
  validate :check_course_event_bookability, unless: :disable_bookability
  before_destroy :check_course_event_unsubscribable, prepend: true

  # TODO private

  def check_max_attendees
    if attendees.count >= room.max_attendees
      errors.add(:course_event_id, I18n.t('errors.messages.max_attendees_reached'))
    end
  end

  def check_valid_subscriptions
    user.active_subscriptions.each do |subscription|
      return true if subscription.category_id == course_event.category_id
    end
    errors.add(:course_event_id, I18n.t('errors.messages.active_subscription_needed'))
    false
  end

  def check_course_event_bookability(datetime=Time.zone.now)
    if datetime < (course_event.event_date - course.start_booking_hours.hours)
      errors.add(:course_event_id, I18n.t('errors.messages.course_event_not_bookable_yet'))
    end
    if datetime > (course_event.event_date - course.end_booking_minutes.minutes)
      errors.add(:course_event_id, I18n.t('errors.messages.course_event_expired'))
    end
  end

  private

  def check_course_event_unsubscribable(datetime=Time.zone.now)
    if datetime >= (course_event.event_date - course.end_booking_minutes.minutes)
      errors.add(:course_event_id, I18n.t('errors.messages.course_event_not_unsubscribable'))
      throw :abort
      false
    end
  end
end
