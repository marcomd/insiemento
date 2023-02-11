class Subscription < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :category
  belongs_to :product
  belongs_to :user, optional: true
  belongs_to :order, optional: true
  has_many :attendees

  before_validation :set_default
  before_save :set_current_state
  after_save :update_user_state

  validates :subscription_type, presence: true
  validates :start_on, presence: { if: :user }
  validates :end_on, presence: { if: -> { user && product } }
  validates :max_accesses_number, presence: { if: -> { %w[trial consumption].include?(subscription_type) } }
  # validates_absence_of :max_accesses_number, if: -> { ['fee'].include? subscription_type } # Removed validation to define a cap

  scope :active_at, ->(date = Time.zone.today) { where('start_on <= :date AND end_on >= :date', date:) }
  scope :not_ended, ->(date = Time.zone.today) { where(state: %i[new active]).where('end_on >= ?', date) }

  # enum type: { TrialSubscription: 10, ConsumptionSubscription: 20, FeeSubscription: 30 }
  enum subscription_type: { trial: 10, consumption: 20, fee: 30 }

  enum state: {
    new: 10,
    active: 20,
    expired: 30,
    consumed: 40,
  }, _suffix: true

  # scope :active, -> (date=Time.zone.today) { where('start_on <= ? and end_on > ?', date, date) }
  # scope :free, -> { where(user_id: nil) }
  # def is_active?(date=Time.zone.today)
  #   start_on <= date && end_on > date
  # end

  def type
    case subscription_type.to_s
    when 'trial'
      TrialSubscription.new(self)
    when 'consumption'
      ConsumptionSubscription.new(self)
    when 'fee'
      FeeSubscription.new(self)
    else
      raise("Unknown subscription type #{subscription_type}")
    end
  end

  def add_attendee(course_event_id)
    attendee = Attendee.new(user_id:, course_event_id:)
    attendees << attendee
    attendee
  end

  private

  def set_current_state(date: Time.zone.today)
    caps = exceeded_caps(date:)
    self.state =
      if caps.include?(:end_on)
        :expired
      elsif caps.include?(:start_on)
        :new
      else
        :active
      end
    type.set_current_state
  end

  def exceeded_caps(date: Time.zone.today)
    caps = []
    caps << :start_on if !start_on || date < start_on
    caps << :end_on   if end_on && date > end_on
    caps
  end

  def update_user_state
    user&.save
  end

  def generate_code
    ([*('A'..'Z'), *('0'..'9')] - %w[0 1 I O]).sample(14).join
  end

  # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
  def set_default
    self.code = generate_code if code.blank?

    # raise 'Product must exist to create a subscription' unless product
    self.state                  ||= :new
    self.start_on               ||= Time.zone.today if user

    return unless product
    self.category_id          ||= product.category_id
    self.subscription_type    ||= product.product_type
    self.max_accesses_number  ||= product.max_accesses_number
    self.end_on               ||= self.start_on + product.days if start_on
  end
  # rubocop:enable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
end
