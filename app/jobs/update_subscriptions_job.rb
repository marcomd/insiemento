class UpdateSubscriptionsJob < ApplicationJob
  queue_as :users

  def perform
    # It deactivates expired subscriptions
    Subscription.where(state: %i[new active]).where('end_on < ?', Time.zone.today).find_in_batches(batch_size: 100) do |group|
      sleep(3) if Rails.env.production?
      group.each(&:save)
    end

    # It activates started subscriptions
    Subscription.where(state: :new).where('start_on <= ?', Time.zone.today).find_in_batches(batch_size: 100) do |group|
      sleep(3) if Rails.env.production?
      group.each(&:save)
    end
  end
end
