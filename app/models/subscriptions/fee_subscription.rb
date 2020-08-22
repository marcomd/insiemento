class FeeSubscription
  include Subscriptionable

  def set_current_state
    subscription.state
  end

  private

end