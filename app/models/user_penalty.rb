class UserPenalty < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :subscription
  belongs_to :course_event
  belongs_to :attendee
  belongs_to :category
  belongs_to :course, optional: true

  validates :attendee_id, uniqueness: { message: I18n.t('errors.messages.already_inhibited') }

  scope :active, ->(date = Time.zone.today) { where('inhibited_until >= ?', date) }
end
