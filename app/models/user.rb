class User < ApplicationRecord
  include Stateable
  include Presentable

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :registerable, :confirmable

  belongs_to :organization
  belongs_to :trainer, optional: true
  has_many :attendees, dependent: :destroy
  has_many :course_events, through: :attendees
  # No, user can have multiple active subscriptions
  # has_one :last_subscription, -> { order id: :desc }, class_name: 'Subscription'
  has_many :subscriptions, dependent: :destroy
  has_many :active_subscriptions, -> { active_state }, class_name: 'Subscription'
  # has_many :active_subscriptions_at, -> (date) { active_at(date) }, class_name: 'Subscription'
  has_many :orders, dependent: :restrict_with_error
  has_one :pending_order, -> { where(state: :just_made) }, class_name: 'Order'
  has_many :payments, dependent: :nullify
  has_many :user_documents, dependent: :restrict_with_error
  has_many :active_user_documents, -> { active }, class_name: 'UserDocument'
  has_many :user_penalties, dependent: :destroy
  has_many :active_user_penalties, -> { active }, class_name: 'UserPenalty'

  has_one_attached :medical_certificate, dependent: :destroy

  validates :medical_certificate, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'application/pdf'], max_size: 2.megabytes }

  validates :email, uniqueness: { allow_blank: false, if: :email_changed? }
  validates     :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true, if: :email_changed? }

  validates     :password, presence: { if: :password_required? }
  validates     :firstname, :lastname, presence: true
  validates :password, confirmation: { if: :password_required? }
  validates :password, length: { within: 8..64, allow_blank: true }
  validates :phone, numericality: { allow_blank: true }
  validates :phone, length: { is: 10, allow_blank: true }

  # scope :with_not_ended_subscriptions, -> (date=Time.zone.today) { where(subscriptions: { state: [:new, :active] })
  #                                                                 .where('subscriptions.end_on >= ?', date)
  #                                                                 .joins(:subscriptions).distinct }
  scope :with_not_ended_subscriptions, ->(_date = Time.zone.today) { joins(:subscriptions).merge(Subscription.not_ended).distinct }
  scope :elegible_for_user_documents, -> { where.not(phone: nil) }
  scope :with_expired_medical_certificate, ->(date = Time.zone.now) { where('medical_certificate_expire_at IS NOT NULL AND medical_certificate_expire_at < ?', date) }

  before_validation :set_default
  # after_save :set_state!
  before_save :set_state, :format_user_data

  STATES = { new: 10,
             active: 20,
             suspended: 30 }.freeze
  enum state: STATES, _suffix: true

  def full_name
    "#{firstname} #{lastname}#{" (#{child_firstname})" if child_firstname.present?}"
  end

  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere.
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def has_active_document?(user_document_model_id)
    # active_user_documents.pluck(:user_document_model_id).include? user_document_model_id
    active_user_documents.where(id: user_document_model_id).count.positive?
  end

  # Use it whether user must accepts all document before booking, work in progress...
  def any_pending_documents?
    organization.user_document_models.active_state.order('id').each do |user_document_model|
      return true unless has_active_document?(user_document_model.id)
    end
    false
  end

  # Not used
  # def any_signed_documents?
  #   organization.user_document_models.active_state.joins(:user_documents).where(user_documents: {user_id: id, state: [:signed, :completed]}).count
  # end
  #
  # def set_state!
  #   any_active_subscriptions = active_subscriptions.count > 0
  #   if any_active_subscriptions
  #     update(state: :active) if !active_state?
  #   else
  #     update(state: :suspended) if active_state?
  #   end
  # end

  def has_minor_child?
    child_firstname.present? && child_lastname.present?
  end

  def is_inhibited?(category_id: nil, course_id: nil)
    inhibitions = active_user_penalties # user_penalties.where('inhibited_until >= ?', Time.zone.today)
    inhibitions = inhibitions.where(category_id:) if category_id
    inhibitions = inhibitions.where(course_id:) if course_id
    inhibitions.last(50).count.positive?
  end

  private

  def set_state
    any_active_subscriptions = active_subscriptions.count.positive?
    if any_active_subscriptions
      self.state = :active unless active_state?
    elsif active_state?
      self.state = :suspended
    end
  end

  def set_default
    self.state ||= :new
  end

  def format_user_data
    self.firstname = firstname&.titleize
    self.lastname = lastname&.titleize
    self.email = email.downcase.strip
    self.phone = phone.gsub(' ', '') if phone&.include?(' ')
  end
end
