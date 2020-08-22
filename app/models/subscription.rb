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

  validates_presence_of :subscription_type
  validates_presence_of :start_on, if: :user
  validates_presence_of :end_on, if: -> { user && product }
  validates_presence_of :max_accesses_number, if: -> { ['trial', 'consumption'].include? subscription_type }
  # validates_absence_of :max_accesses_number, if: -> { ['fee'].include? subscription_type } # Removed validation to define a cap

  # enum type: { TrialSubscription: 10, ConsumptionSubscription: 20, FeeSubscription: 30 }
  enum subscription_type: { trial: 10, consumption: 20, fee: 30 }

  enum state: {
      new:                    10,
      active:                 20,
      expired:                30,
      consumed:               40,
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
      raise "Unknown subscription type #{subscription_type}"
    end
  end

  def add_attendee(course_event_id)
    _attendee = Attendee.new(user_id: user_id, course_event_id: course_event_id)
    attendees << _attendee
    _attendee
  end

  private

  def set_current_state(date=Time.zone.today)
    _exceeded_caps = exceeded_caps(date)
    self.state =
        if _exceeded_caps.include?(:end_on)
          :expired
        elsif _exceeded_caps.include?(:start_on)
          :new
        else
          :active
        end
    type.set_current_state
  end

  def exceeded_caps(date=Time.zone.today)
    _exceeded_caps = []
    _exceeded_caps << :start_on if !start_on || date < start_on
    _exceeded_caps << :end_on   if end_on && date > end_on
    _exceeded_caps
  end

  def set_default
    self.code ||= ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(14).join # Faster than SecureRandom.alphanumeric(14).upcase or SecureRandom.hex(7)

    #raise 'Product must exist to create a subscription' unless product
    self.state                  ||= :new
    self.start_on               ||= Time.zone.today if user

    if product
      self.category_id          ||= product&.category_id
      self.subscription_type    ||= product&.product_type
      self.max_accesses_number  ||= product&.max_accesses_number
      self.end_on               ||= self.start_on + product.days if start_on
    end

  end
end
