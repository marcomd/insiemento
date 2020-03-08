class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :registerable, :confirmable

  belongs_to :organization
  has_many :attendees, dependent: :destroy
  has_many :course_events, through: :attendees
  # No, user can have multiple active subscriptions
  #has_one :last_subscription, -> { order id: :desc }, class_name: 'Subscription'
  has_many :subscriptions
  has_many :active_subscriptions, -> { active }, class_name: 'Subscription'

  validates_uniqueness_of :email, allow_blank: false, if: :email_changed?
  validates_format_of     :email, with: URI::MailTo::EMAIL_REGEXP, allow_blank: true, if: :email_changed?

  validates_presence_of     :password, if: :password_required?
  validates_presence_of     :firstname, :lastname
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: 8..64, allow_blank: true

  STATES = { just_made: 10, active: 20, suspended: 30}
  enum state: STATES

  def full_name
    "#{firstname} #{lastname}"
  end

  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere.
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
