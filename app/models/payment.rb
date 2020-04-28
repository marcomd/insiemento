class Payment < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :user, optional: true
  belongs_to :order, optional: true

  after_create :add_to_order!, if: :order
  after_update :update_order!, if: :order

  enum source: { stripe: 0, paypal: 1, cc: 2 }, _prefix: true

  STATES = { just_made: 10, canceled: 30, confirmed: 40}
  enum state: STATES

  ACTIVE_STATES = [:just_made]
  UNACTIVE_STATES = [:canceled, :confirmed]

  monetize :amount_cents

  # It uses comma as thousand separator
  ransacker :amount, formatter: proc { |v| v.sub(',','.').to_r * 100 } do |parent|
    parent.table[:amount_cents]
  end

  def confirm!
    update! state: :confirmed
  end

  private

  def add_to_order!
    return if order.blank? || !confirmed?
    order.update_paid_amounts!
  end

  def update_order!
    return unless order
    order.update_paid_amounts!
  end
end
