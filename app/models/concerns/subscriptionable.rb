module Subscriptionable
  extend ActiveSupport::Concern

  included do
    attr_accessor :subscription
    delegate :uuid, :start_on, :end_on, :state, :max_accesses_number, :attendees, to: :subscription
    # validate :type_specific_validation
  end

  def initialize(subscription)
    @subscription = subscription
  end

  # def type_specific_validation
  #   type.validate_subscription
  # end

  def to_s
    "Subscription type: #{subscription.subscription_type}"
  end
end
