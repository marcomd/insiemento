class Payment < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :user, optional: true
  belongs_to :order, optional: true

  after_create :update_order!, if: :order

  enum source: { stripe: 0, paypal: 1, cc: 2 }, _prefix: true

  STATES = { just_made: 10, canceled: 30, confirmed: 40}
  enum state: STATES

  def update_order!
    return unless order
    order.update_paid_amounts!
  end
end
