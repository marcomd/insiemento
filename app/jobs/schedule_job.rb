class ScheduleJob < ApplicationJob
  queue_as :course_events
  sidekiq_options retry: 1

  def perform
    service = ScheduleService.call
    if !service.success?
      SystemLog.create!(message: "ScheduleJob success: #{service.success?} #{service.errors}")
    end
  # rescue
  #   SystemLog.create!(message: "ScheduleJob failed: #{$!.message}")
  end
end
