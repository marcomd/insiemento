class User < ApplicationRecord
  include Stateable

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :registerable, :confirmable

  belongs_to :organization
  belongs_to :trainer, optional: true
  has_many :attendees, dependent: :destroy
  has_many :course_events, through: :attendees
  # No, user can have multiple active subscriptions
  #has_one :last_subscription, -> { order id: :desc }, class_name: 'Subscription'
  has_many :subscriptions, dependent: :destroy
  has_many :active_subscriptions, -> { active_state }, class_name: 'Subscription'
  # has_many :active_subscriptions_at, -> (date) { active_at(date) }, class_name: 'Subscription'
  has_many :orders, dependent: :restrict_with_error
  has_one :pending_order, -> { where(state: :just_made) }, class_name: 'Order'
  has_many :payments, dependent: :nullify
  has_many :user_documents, dependent: :restrict_with_error
  has_many :active_user_documents, -> { active }, class_name: 'UserDocument'

  has_one_attached :medical_certificate, dependent: :destroy

  validates :medical_certificate, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'application/pdf'], max_size: 2.megabytes }

  validates_uniqueness_of :email, allow_blank: false, if: :email_changed?
  validates_format_of     :email, with: URI::MailTo::EMAIL_REGEXP, allow_blank: true, if: :email_changed?

  validates_presence_of     :password, if: :password_required?
  validates_presence_of     :firstname, :lastname
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: 8..64, allow_blank: true
  validates_numericality_of :phone, allow_blank: true
  validates_length_of :phone, is: 10, allow_blank: true

  # scope :with_not_ended_subscriptions, -> (date=Time.zone.today) { where(subscriptions: { state: [:new, :active] })
  #                                                                 .where('subscriptions.end_on >= ?', date)
  #                                                                 .joins(:subscriptions).distinct }
  scope :with_not_ended_subscriptions, -> (date=Time.zone.today) { joins(:subscriptions).merge(Subscription.not_ended).distinct }
  scope :elegible_for_user_documents, -> { where.not(phone: nil) }

  before_validation :set_default
  # after_save :set_state!
  before_save :set_state, :format_user_data

  STATES = { new: 10,
             active: 20,
             suspended: 30}
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
    active_user_documents.where(id: user_document_model_id).count > 0
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
    self.child_firstname.present? && self.child_lastname.present?
  end

  private

  def set_state
    any_active_subscriptions = active_subscriptions.count > 0
    if any_active_subscriptions
      self.state = :active if !active_state?
    else
      self.state = :suspended if active_state?
    end
  end

  def set_default
    self.state ||= :new
  end

  def format_user_data
    self.firstname = self.firstname&.titleize
    self.lastname = self.lastname&.titleize
    self.email = self.email.downcase.strip
    self.phone = self.phone.gsub(' ', '') if self.phone&.include?(' ')
  end
end
