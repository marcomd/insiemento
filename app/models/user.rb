class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :registerable, :confirmable

  has_many :attendees, dependent: :nullify
  has_many :course_events, through: :attendees

  validates_uniqueness_of :email, allow_blank: false, if: :email_changed?
  validates_format_of     :email, with: URI::MailTo::EMAIL_REGEXP, allow_blank: true, if: :email_changed?

  validates_presence_of     :password, :firstname, :lastname, :phone
  validates_confirmation_of :password
  validates_length_of       :password, within: 8..64, allow_blank: true

  STATES = { just_made: 10, active: 20, suspended: 30}
  enum state: STATES

end
