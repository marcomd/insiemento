class Payment < ApplicationRecord
  include Stateable

  belongs_to :organization
  belongs_to :user, optional: true
  belongs_to :order, optional: true

  after_create :add_to_order!, if: :order
  after_create :external_service_response_or_create
  after_update :update_order!, if: :order

  enum source: { frontend: 0, backend: 1 }, _prefix: true
  enum type: { StripePayment: 0, PaypalPayment: 1, BankTransferPayment: 2 }

  STATES = { just_made: 10, canceled: 30, synched: 40, confirmed: 50}
  enum state: STATES

  # validate :check_json_format
  validates :external_service_response, json: {message: :invalid_json_format}

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

  # This method must be overridden in subclasses
  def external_service_response_or_create
    raise "Please override in the subclass #{self.class.name}"
  end

  def add_to_order!
    return if order.blank? || !confirmed?
    order.update_paid_amounts!
  end

  def update_order!
    return unless order
    order.update_paid_amounts!
  end

  # def check_json_format
  #   errors[:external_service_response] << 'not in json format' unless external_service_response.is_json?
  # end
end
