class UserPenaltyJob < ApplicationJob
  queue_as :users

  def perform
    service = PenaltyService.call
    if !service.success?
      SystemLog.create!(message: "UserPenaltyJob success: #{service.success?} #{service.errors}")
    end
  end
end
