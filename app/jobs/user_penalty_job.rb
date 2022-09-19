class UserPenaltyJob < ApplicationJob
  queue_as :users

  def perform
    service = PenaltyService.call
    SystemLog.create!(message: "UserPenaltyJob success: #{service.success?} #{service.errors}") unless service.success?
  end
end
