class TrialSubscription
  include Subscriptionable

  def set_current_state
    _exceeded_caps = exceeded_caps
    subscription.state = :consumed if state == 'active' && [:max_accesses_number].intersect?(_exceeded_caps)
    subscription.state
  end

  private

  def exceeded_caps(_date = Time.zone.today)
    _exceeded_caps = []
    _exceeded_caps << :max_accesses_number if max_accesses_number && attendees.count >= max_accesses_number
    _exceeded_caps
  end
end
