class Order < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :user
  belongs_to :approver_admin_user, class_name: 'AdminUser', optional: true
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products
  has_many :payments, dependent: :restrict_with_error
  has_many :stripe_payments
  has_many :paypal_payments
  has_many :subscriptions

  after_create :set_amounts!, if: :updatable?
  after_update :set_amounts!, if: :updatable?
  attr_accessor :disable_set_amounts

  accepts_nested_attributes_for :order_products, reject_if: ->(obj) { obj[:product_id].blank? }, allow_destroy: true

  STATES = { just_made: 10, processing: 20, canceled: 30, completed: 40 }.freeze
  enum state: STATES

  ACTIVE_STATES = %i[just_made processing].freeze
  UNACTIVE_STATES = %i[canceled completed].freeze

  enum currency: { eur: 0, usd: 1 }

  monetize :total_amount_cents, :amount_to_pay_cents, :discount_cents, :amount_paid_cents

  # It uses comma as thousand separator
  ransacker :total_amount, formatter: proc { |v| v.sub(',', '.').to_r * 100 } do |parent|
    parent.table[:total_amount_cents]
  end
  ransacker :amount_to_pay, formatter: proc { |v| v.sub(',', '.').to_r * 100 } do |parent|
    parent.table[:amount_to_pay_cents]
  end
  ransacker :discount, formatter: proc { |v| v.sub(',', '.').to_r * 100 } do |parent|
    parent.table[:discount_cents]
  end
  ransacker :amount_paid, formatter: proc { |v| v.sub(',', '.').to_r * 100 } do |parent|
    parent.table[:amount_paid_cents]
  end

  include AASM
  aasm :state, column: :state, enum: true do
    state :just_made, initial: true
    state :processing, :canceled, :completed

    event :start_process do
      transitions from: :just_made, to: :processing
    end

    event :complete do
      transitions from: %i[just_made processing], to: :completed, success: :create_subscriptions
    end

    event :cancel do
      transitions from: %i[just_made processing], to: :canceled
    end

    event :resume do
      transitions from: :canceled, to: :processing
    end
  end

  def update_paid_amounts!
    self.amount_paid_cents = payments.confirmed.pluck(:amount_cents).sum
    set_state!
  end

  def name
    "User #{user_id} #{start_on} #{Money.new(amount_to_pay_cents)}"
  end

  private

  def set_amounts!
    self.disable_set_amounts = true
    self.total_amount_cents = products.sum(&:price_cents)
    self.amount_to_pay_cents = total_amount_cents - discount_cents
    result = save!
    self.disable_set_amounts = nil
    result
  end

  def set_state!
    bol_saved =
      if amount_paid_cents == amount_to_pay_cents
        complete! if may_complete?
      elsif may_start_process?
        start_process!
      end
    bol_saved || save!
  end

  # Move it in a service if this method become more complex
  def create_subscriptions
    products.each do |product|
      subscriptions << Subscription.new(organization:,
                                        product:,
                                        user:,
                                        start_on: Time.zone.today)
    end
  end

  def updatable?
    !disable_set_amounts && (just_made? || processing?)
  end
end
