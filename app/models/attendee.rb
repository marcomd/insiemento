class Attendee < ApplicationRecord
  belongs_to :user
  belongs_to :course_event
  has_one :room, through: :course_event
  has_many :attendees, through: :course_event

  validates :course_event_id, uniqueness: { scope: :user_id,
                                 message: I18n.t('errors.messages.already_subscribed') }
  validate :check_max_attendees, :check_valid_subscriptions

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
end
