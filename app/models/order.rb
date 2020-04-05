class Order < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :user
  belongs_to :approver_admin_user, class_name: 'AdminUser', optional: true
  has_and_belongs_to_many :products
  has_many :payments
  has_many :subscriptions

  after_create :set_amounts!
  #after_update :update_paid_amounts!

  STATES = { just_made: 10, processing: 20, canceled: 30, completed: 40}
  enum state: STATES

  enum currency: { eur: 0, usd: 1 }

  monetize :total_amount_cents, :amount_to_pay_cents, :discount_cents, :amount_paid_cents

  include AASM
  aasm :state, column: :state, enum: true do
    state :just_made, initial: true
    state :processing, :canceled, :completed

    event :start_process do
      transitions from: :just_made, to: :processing
    end

    event :complete do
      transitions from: [:just_made, :processing], to: :completed, success: :create_subscriptions
    end

    event :cancel do
      transitions from: [:just_made, :processing], to: :canceled
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
    self.total_amount_cents = products.pluck(:price_cents).sum
    self.amount_to_pay_cents = self.total_amount_cents - self.discount_cents
    save!
  end

  def set_state!
    bol_saved =
      if self.amount_paid_cents == self.amount_to_pay_cents
        self.complete! if may_complete?
      else
        self.start_process! if self.may_start_process?
      end
    bol_saved || save!
  end

  # Move it in a service if this method become more complex
  def create_subscriptions
    products.each do |product|
      subscriptions << Subscription.new(organization: organization, category_id: product.category_id, product: product,
                                        user: user, start_on: Time.zone.today, end_on: Time.zone.today + product.days)
    end
  end
end
