class Attendee < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :course_event, counter_cache: :attendees_count
  belongs_to :subscription
  has_one :room, through: :course_event
  has_one :course, through: :course_event
  has_many :attendees, through: :course_event

  attr_accessor :disable_bookability
  validates :course_event_id, uniqueness: { scope: :user_id,
                                 message: I18n.t('errors.messages.already_subscribed') }
  validate :check_max_attendees, :check_valid_subscriptions
  validate :check_course_event_bookability, unless: :disable_bookability

  before_validation :check_valid_subscriptions
  before_destroy :check_course_event_unsubscribable, prepend: true
  after_create :update_subscription
  after_destroy :update_subscription

  scope :present_at_this_time, -> (date=Time.zone.now) { where(presence: true).where('updated_at > ?', date - 70.minutes) }

  private

  def check_max_attendees
    if attendees.count >= room.max_attendees
      errors.add(:course_event_id, I18n.t('errors.messages.max_attendees_reached'))
    end
  end

  def check_valid_subscriptions
    self.organization_id ||= user.organization_id
    # user.active_subscriptions.each do |subscription|
    user.subscriptions.active_at(course_event.event_date).each do |subscription|
      if subscription.category_id == course_event.category_id
        self.subscription_id = subscription.id
        return true
      end
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
    if course_event.suspended?
      errors.add(:course_event_id, I18n.t('errors.messages.course_event_suspended'))
    elsif course_event.closed?
      errors.add(:course_event_id, I18n.t('errors.messages.course_event_closed'))
    end
    !errors.present?
  end

  def check_course_event_unsubscribable(datetime=Time.zone.now)
    if datetime >= (course_event.event_date - course.end_booking_minutes.minutes)
      errors.add(:course_event_id, I18n.t('errors.messages.course_event_not_unsubscribable'))
      throw :abort
      false
    end
    true
  end

  def update_subscription
    subscription.save
  end
end
