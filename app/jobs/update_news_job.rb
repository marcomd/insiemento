class UpdateNewsJob < ApplicationJob
  queue_as :news

  def perform
    News.active_state.where('expire_on < ?', Time.zone.today).update_all(state: :expired, updated_at: Time.zone.now)
  end
end
