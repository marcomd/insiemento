class Attendee < ApplicationRecord
  belongs_to :user
  belongs_to :course_event
  validates :course_event_id, uniqueness: { scope: :user_id,
                                 message: I18n.t('errors.messages.already_subscribed') }

end
