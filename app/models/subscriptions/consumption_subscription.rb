class ConsumptionSubscription
  include Subscriptionable

  def set_current_state
    caps = exceeded_caps
    subscription.state = :consumed if state == 'active' && [:max_accesses_number].intersect?(caps)
    subscription.state
  end

  private

  def exceeded_caps
    caps = []
    caps << :max_accesses_number if max_accesses_number && attendees.count >= max_accesses_number
    caps
  end
end
